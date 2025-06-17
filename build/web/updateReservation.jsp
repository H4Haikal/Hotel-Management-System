<%@page import="java.sql.*, java.time.*, java.time.format.*, hotel.management.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8" session="true"%>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String reservationID = request.getParameter("reservationID");
    String message = "";

    String guestName = "", guestAddr = "", guestPhone = "", guestEmail = "", roomType = "";
    int roomNo = 0;
    String checkInDate = "", checkOutDate = "";

    if (request.getMethod().equalsIgnoreCase("POST")) {
        // Handle update
        guestName = request.getParameter("guestName");
        guestAddr = request.getParameter("guestAddr");
        guestPhone = request.getParameter("guestPhone");
        guestEmail = request.getParameter("guestEmail");
        checkInDate = request.getParameter("checkInDate");
        checkOutDate = request.getParameter("checkOutDate");
        roomNo = Integer.parseInt(request.getParameter("roomNo"));
        roomType = request.getParameter("roomType");

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime in = LocalDateTime.parse(checkInDate, formatter);
            LocalDateTime checkOutDateTime = LocalDateTime.parse(checkOutDate, formatter);
            if (in.isBefore(LocalDateTime.now()) || !checkOutDateTime.isAfter(in)) {

                message = "Invalid date. Check-out must be after check-in and in the future.";
            } else {
                // Get guestID
                String guestID = "";
                PreparedStatement ps = conn.prepareStatement("SELECT guestID FROM reservation WHERE reservationID=?");
                ps.setString(1, reservationID);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    guestID = rs.getString(1);
                }

                // Update guest info
                ps = conn.prepareStatement("UPDATE guest SET guestName=?, guestAddr=?, guestPhone=?, guestEmail=? WHERE guestID=?");
                ps.setString(1, guestName);
                ps.setString(2, guestAddr);
                ps.setString(3, guestPhone);
                ps.setString(4, guestEmail);
                ps.setString(5, guestID);
                ps.executeUpdate();

                // Update reservation info
                ps = conn.prepareStatement("UPDATE reservation SET checkInDate=?, checkOutDate=?, roomType=?, roomNo=? WHERE reservationID=?");
                ps.setString(1, checkInDate);
                ps.setString(2, checkOutDate);
                ps.setString(3, roomType);
                ps.setInt(4, roomNo);
                ps.setString(5, reservationID);
                ps.executeUpdate();

                conn.commit();
                response.sendRedirect("viewReservation.jsp?msg=Reservation+updated+successfully");
                return;

            }
        } catch (Exception e) {
            message = "Update failed: " + e.getMessage();
            e.printStackTrace();
        }
    } else {
        // Load existing values
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                    "SELECT g.*, r.* FROM reservation r JOIN guest g ON r.guestID = g.guestID WHERE r.reservationID = ?"
            );
            ps.setString(1, reservationID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                guestName = rs.getString("guestName");
                guestAddr = rs.getString("guestAddr");
                guestPhone = rs.getString("guestPhone");
                guestEmail = rs.getString("guestEmail");
                checkInDate = rs.getString("checkInDate").replace(" ", "T");
                checkOutDate = rs.getString("checkOutDate").replace(" ", "T");
                roomType = rs.getString("roomType");
                roomNo = rs.getInt("roomNo");
            }
        } catch (Exception e) {
            message = "Failed to load reservation: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Update Reservation</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <%@ include file="include/sidebar.jsp" %>

        <div class="container mt-4" style="margin-left: 250px;">
            <h2 class="mb-4">Edit Reservation - <%= reservationID%></h2>

            <% if (!message.isEmpty()) {%>
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                <%= message%>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% }%>

            <form method="post">
                <input type="hidden" name="reservationID" value="<%= reservationID%>">

                <div class="mb-3">
                    <label>Guest Name:</label>
                    <input type="text" name="guestName" class="form-control" value="<%= guestName%>" required>
                </div>
                <div class="mb-3">
                    <label>Address:</label>
                    <input type="text" name="guestAddr" class="form-control" value="<%= guestAddr%>" required>
                </div>
                <div class="mb-3">
                    <label>Phone:</label>
                    <input type="text" name="guestPhone" class="form-control" value="<%= guestPhone%>" required>
                </div>
                <div class="mb-3">
                    <label>Email:</label>
                    <input type="email" name="guestEmail" class="form-control" value="<%= guestEmail%>" required>
                </div>

                <div class="mb-3">
                    <label>Room Type:</label>
                    <select name="roomType" class="form-control" required>
                        <option value="Standard" <%= roomType.equals("Standard") ? "selected" : ""%>>Standard</option>
                        <option value="Deluxe" <%= roomType.equals("Deluxe") ? "selected" : ""%>>Deluxe</option>
                        <option value="Suite" <%= roomType.equals("Suite") ? "selected" : ""%>>Suite</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label>Room No:</label>
                    <input type="number" name="roomNo" class="form-control" value="<%= roomNo%>" required>
                </div>

                <div class="mb-3">
                    <label>Check-In Date:</label>
                    <input type="datetime-local" name="checkInDate" class="form-control" value="<%= checkInDate%>" required>
                </div>

                <div class="mb-3">
                    <label>Check-Out Date:</label>
                    <input type="datetime-local" name="checkOutDate" class="form-control" value="<%= checkOutDate%>" required>
                </div>

                <button type="submit" class="btn btn-primary">Update</button>
                <a href="viewReservation.jsp" class="btn btn-secondary">Cancel</a>
            </form>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
