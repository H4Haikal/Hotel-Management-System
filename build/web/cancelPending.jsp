<%@page import="java.sql.*, hotel.management.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String reservationID = request.getParameter("reservationID");
    String roomNo = request.getParameter("roomNo");
    String msg = "";

    if (reservationID != null && roomNo != null) {
        try (Connection conn = DBConnection.getConnection()) {

            // Delete the reservation
            PreparedStatement ps1 = conn.prepareStatement("DELETE FROM reservation WHERE reservationID = ?");
            ps1.setString(1, reservationID);
            int result = ps1.executeUpdate();

            // Set room back to available
            PreparedStatement ps2 = conn.prepareStatement("UPDATE room SET roomStatus = 'available' WHERE roomNo = ?");
            ps2.setString(1, roomNo);
            ps2.executeUpdate();

            msg = (result > 0) ? "Reservation " + reservationID + " has been cancelled." : "Failed to cancel reservation.";
        } catch (Exception e) {
            msg = "Error cancelling reservation: " + e.getMessage();
        }
    } else {
        msg = "Missing reservation ID or room number.";
    }

    response.sendRedirect("checkin.jsp?msg=" + java.net.URLEncoder.encode(msg, "UTF-8"));
%>
