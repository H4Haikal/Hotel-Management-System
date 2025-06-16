<%@page import="java.sql.*, java.util.*, hotel.management.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>
<%@ page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"  %>

<%
    LocalDateTime now = LocalDateTime.now();
    String todayISO = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
%>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String selectedRoomType = request.getParameter("roomType");
    if (selectedRoomType == null) {
        selectedRoomType = "";
    }

    // Load available rooms
    List<Map<String, Object>> availableRooms = new ArrayList<>();
    if (!selectedRoomType.isEmpty()) {
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                    "SELECT roomNo, roomType, roomPrice, roomStatus FROM room WHERE roomType = ? AND roomStatus = 'available'"
            );
            ps.setString(1, selectedRoomType);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> room = new HashMap<>();
                room.put("roomNo", rs.getInt("roomNo"));
                room.put("roomType", rs.getString("roomType"));
                room.put("roomPrice", rs.getBigDecimal("roomPrice"));
                room.put("roomStatus", rs.getString("roomStatus"));
                availableRooms.add(room);
            }
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error loading rooms: " + e.getMessage() + "</div>");
        }
    }

    // Retrieve user-filled values
    String guestName = request.getParameter("guestName");
    String guestAddr = request.getParameter("guestAddr");
    String guestPhone = request.getParameter("guestPhone");
    String guestEmail = request.getParameter("guestEmail");
    String checkInDate = request.getParameter("checkInDate");
    String checkOutDate = request.getParameter("checkOutDate");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Make Reservation</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .main-content {
                margin-left: 250px;
                padding: 20px;
            }
            .room-grid {
                display: flex;
                gap: 15px;
                flex-wrap: wrap;
                margin-bottom: 20px;
            }
            .room-square {
                width: 100px;
                height: 100px;
                background: #198754;
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                border-radius: 8px;
                cursor: pointer;
                position: relative;
                user-select: none;
                transition: background-color 0.3s;
            }
            .room-square:hover {
                background: #14532d;
            }
            .room-square .tooltip-info {
                visibility: hidden;
                width: 180px;
                background-color: black;
                color: #fff;
                text-align: left;
                border-radius: 6px;
                padding: 8px;
                position: absolute;
                z-index: 1;
                bottom: 110%;
                left: 50%;
                margin-left: -90px;
                opacity: 0;
                transition: opacity 0.3s;
                font-size: 0.9rem;
                pointer-events: none;
            }
            .room-square:hover .tooltip-info {
                visibility: visible;
                opacity: 1;
            }
            .room-square.selected {
                border: 3px solid #ffc107;
            }
        </style>
    </head>
    <body class="bg-light">
        <%@ include file="include/sidebar.jsp" %>

        <div class="main-content">
            <% String message = (String) request.getAttribute("message");
                if (message != null) {%>
            <div class="alert alert-info mt-3"><%= message%></div>
            <% }%>
            <h2 class="mb-4">Make a Reservation</h2>
            <form action="addReservation.jsp" method="post" onsubmit="return validateRoomSelection()">
                <h4>Guest Info</h4>
                <div class="mb-3">
                    <label>Guest Name:</label>
                    <input type="text" name="guestName" class="form-control" required
                           value="<%= guestName != null ? guestName : ""%>">
                </div>
                <div class="mb-3">
                    <label>Address:</label>
                    <input type="text" name="guestAddr" class="form-control" required
                           value="<%= guestAddr != null ? guestAddr : ""%>">
                </div>
                <div class="mb-3">
                    <label>Phone:</label>
                    <input type="text" name="guestPhone" class="form-control" required
                           value="<%= guestPhone != null ? guestPhone : ""%>">
                </div>
                <div class="mb-3">
                    <label>Email:</label>
                    <input type="email" name="guestEmail" class="form-control" required
                           value="<%= guestEmail != null ? guestEmail : ""%>">
                </div>

                <h4>Reservation Info</h4>
                <div class="mb-3">
                    <label>Room Type:</label>
                    <select name="roomType" class="form-control" required onchange="this.form.submit()">
                        <option value="">--Select--</option>
                        <option value="Standard" <%= "Standard".equals(selectedRoomType) ? "selected" : ""%>>Standard</option>
                        <option value="Deluxe" <%= "Deluxe".equals(selectedRoomType) ? "selected" : ""%>>Deluxe</option>
                        <option value="Suite" <%= "Suite".equals(selectedRoomType) ? "selected" : ""%>>Suite</option>
                    </select>
                </div>

                <% if (!availableRooms.isEmpty()) { %>
                <h5>Select Room (click a room):</h5>
                <div class="room-grid">
                    <% for (Map<String, Object> room : availableRooms) {%>
                    <div class="room-square" data-roomno="<%=room.get("roomNo")%>">
                        Room <%=room.get("roomNo")%>
                        <div class="tooltip-info">
                            Type: <%=room.get("roomType")%><br/>
                            Price: RM <%=room.get("roomPrice")%><br/>
                            Status: <%=room.get("roomStatus")%>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } else if (!selectedRoomType.isEmpty()) { %>
                <p class="text-warning">No available rooms for the selected type.</p>
                <% }%>

                <div class="mb-3">
                    <label>Check-In Date:</label>
                    <input type="datetime-local" name="checkInDate" id="checkInDate" class="form-control" required
                           min="<%= todayISO%>"
                           value="<%= checkInDate != null ? checkInDate : ""%>">
                </div>
                <div class="mb-3">
                    <label>Check-Out Date:</label>
                    <input type="datetime-local" name="checkOutDate" id="checkOutDate" class="form-control" required
                           min="<%= todayISO%>"
                           value="<%= checkOutDate != null ? checkOutDate : ""%>">
                </div>


                <input type="hidden" name="selectedRoomNo" id="selectedRoomNo" value="<%= request.getParameter("selectedRoomNo") != null ? request.getParameter("selectedRoomNo") : ""%>">

                <button type="submit" class="btn btn-success">Submit Reservation</button>
            </form>



            <script>
                // Retain previously selected room
                const prevSelected = document.getElementById('selectedRoomNo').value;
                if (prevSelected) {
                    const selectedDiv = document.querySelector(`.room-square[data-roomno="${prevSelected}"]`);
                    if (selectedDiv)
                        selectedDiv.classList.add('selected');
                }

                // Handle room selection
                document.querySelectorAll('.room-square').forEach(square => {
                    square.addEventListener('click', () => {
                        document.querySelectorAll('.room-square').forEach(s => s.classList.remove('selected'));
                        square.classList.add('selected');
                        document.getElementById('selectedRoomNo').value = square.getAttribute('data-roomno');
                    });
                });

                // Form validation
                function validateRoomSelection() {
                    const selectedRoom = document.getElementById('selectedRoomNo').value;
                    if (!selectedRoom) {
                        alert('Please select a room before submitting.');
                        return false;
                    }
                    return true;
                }
            </script>
            <script>
                const checkIn = document.getElementById("checkInDate");
                const checkOut = document.getElementById("checkOutDate");

                if (checkIn && checkOut) {
                    checkIn.addEventListener("change", () => {
                        checkOut.min = checkIn.value;
                        if (checkOut.value < checkIn.value) {
                            checkOut.value = checkIn.value;
                        }
                    });
                }
            </script>

    </body>
</html>
