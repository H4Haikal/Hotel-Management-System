<%@page import="java.sql.*, java.util.*, hotel.management.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String selectedRoomType = request.getParameter("roomType");
    if (selectedRoomType == null) {
        selectedRoomType = "";
    }

    List<Map<String, Object>> availableRooms = new ArrayList<>();
    if (!selectedRoomType.isEmpty()) {
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                    "SELECT roomNo, roomType, roomPrice, roomStatus FROM room WHERE roomType = ?"
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

    // Preserve form data
    String guestName = request.getParameter("guestName");
    String guestAddr = request.getParameter("guestAddr");
    String guestPhone = request.getParameter("guestPhone");
    String guestEmail = request.getParameter("guestEmail");
    String checkInDate = request.getParameter("checkInDate");
    String checkOutDate = request.getParameter("checkOutDate");
    String selectedRoomNo = request.getParameter("selectedRoomNo");
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
                flex-wrap: wrap;
                gap: 10px;
            }

            .room-square {
                width: 100px;
                height: 100px;
                background-color: #198754;
                color: #fff;
                font-weight: bold;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 8px;
                position: relative;
                cursor: pointer;
            }

            .room-square:hover {
                background-color: #14532d;
            }

            .room-square .tooltip-info {
                visibility: hidden;
                width: 180px;
                background-color: rgba(0, 0, 0, 0.85);
                color: #fff;
                text-align: left;
                padding: 8px;
                border-radius: 6px;
                position: absolute;
                z-index: 10;
                bottom: 110%;
                left: 50%;
                transform: translateX(-50%);
                font-size: 0.85rem;
            }

            .room-square:hover .tooltip-info {
                visibility: visible;
            }

            .room-square.selected {
                border: 4px solid #ffc107;
            }
        </style>
    </head>
    <body class="bg-light">
        <%@ include file="include/sidebar.jsp" %>

        <div class="main-content">
            <h2>Make a Reservation</h2>

            <% String message = (String) request.getAttribute("message");
                if (message != null && !message.isEmpty()) {%>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <%= message%>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% }%>

            <form action="addReservation.jsp" method="post" onsubmit="return validateForm()">
                <h5>Guest Information</h5>
                <div class="mb-3">
                    <label>Guest Name:</label>
                    <input type="text" name="guestName" class="form-control" required value="<%= guestName != null ? guestName : ""%>">
                </div>
                <div class="mb-3">
                    <label>Address:</label>
                    <input type="text" name="guestAddr" class="form-control" required value="<%= guestAddr != null ? guestAddr : ""%>">
                </div>
                <div class="mb-3">
                    <label>Phone:</label>
                    <input type="text" name="guestPhone" class="form-control" required value="<%= guestPhone != null ? guestPhone : ""%>">
                </div>
                <div class="mb-3">
                    <label>Email:</label>
                    <input type="email" name="guestEmail" class="form-control" required value="<%= guestEmail != null ? guestEmail : ""%>">
                </div>

                <h5>Reservation Info</h5>
                <div class="mb-3">
                    <label>Room Type:</label>
                    <select name="roomType" class="form-control" required onchange="this.form.submit()">
                        <option value="">-- Select --</option>
                        <option value="Standard" <%= "Standard".equals(selectedRoomType) ? "selected" : ""%>>Standard</option>
                        <option value="Deluxe" <%= "Deluxe".equals(selectedRoomType) ? "selected" : ""%>>Deluxe</option>
                        <option value="Suite" <%= "Suite".equals(selectedRoomType) ? "selected" : ""%>>Suite</option>
                    </select>
                </div>

                <% if (!availableRooms.isEmpty()) { %>
                <h6>Select Room:</h6>
                <div class="room-grid mb-3">
                    <% for (Map<String, Object> room : availableRooms) {
                            int roomNo = (int) room.get("roomNo");
                            String status = room.get("roomStatus").toString();
                            boolean isSelected = String.valueOf(roomNo).equals(selectedRoomNo);
                    %>
                    <div class="room-square <%= isSelected ? "selected" : ""%>" data-roomno="<%= roomNo%>">
                        <%= roomNo%>
                        <div class="tooltip-info">
                            Type: <%= room.get("roomType")%><br/>
                            Price: RM <%= room.get("roomPrice")%><br/>
                            Status: <%= status%>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } else if (!selectedRoomType.isEmpty()) { %>
                <div class="text-danger mb-3">No rooms found for selected type.</div>
                <% }%>

                <input type="hidden" id="selectedRoomNo" name="selectedRoomNo" value="<%= selectedRoomNo != null ? selectedRoomNo : ""%>">

                <div class="mb-3">
                    <label>Check-In Date:</label>
                    <input type="datetime-local" name="checkInDate" id="checkInDate" class="form-control" required value="<%= checkInDate != null ? checkInDate : ""%>">
                </div>
                <div class="mb-3">
                    <label>Check-Out Date:</label>
                    <input type="datetime-local" name="checkOutDate" id="checkOutDate" class="form-control" required value="<%= checkOutDate != null ? checkOutDate : ""%>">
                </div>

                <button type="submit" class="btn btn-success">Submit Reservation</button>
            </form>
        </div>

        <script>
            // Handle room selection
            document.querySelectorAll('.room-square').forEach(square => {
                square.addEventListener('click', () => {
                    document.querySelectorAll('.room-square').forEach(sq => sq.classList.remove('selected'));
                    square.classList.add('selected');
                    document.getElementById('selectedRoomNo').value = square.dataset.roomno;
                });
            });

            // Set minimum datetime for input fields to now
            const now = new Date();
            const pad = n => n < 10 ? '0' + n : n;
            var minDate = now.getFullYear() + '-' + pad(now.getMonth() + 1) + '-' + pad(now.getDate()) +
                    'T' + pad(now.getHours()) + ':' + pad(now.getMinutes());

            document.getElementById('checkInDate').setAttribute('min', minDate);
            document.getElementById('checkOutDate').setAttribute('min', minDate);
            document.getElementById('checkInDate').setAttribute('min', minDate);
            document.getElementById('checkOutDate').setAttribute('min', minDate);

            function validateForm() {
                const selected = document.getElementById('selectedRoomNo').value;
                if (!selected) {
                    alert("Please select a room before submitting.");
                    return false;
                }
                return true;
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
