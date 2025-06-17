package hotel.management;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

public class DeleteReservationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String reservationID = request.getParameter("reservationID");
        String message;

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement check = conn.prepareStatement("SELECT status FROM reservation WHERE reservationID=?");
            check.setString(1, reservationID);
            ResultSet rs = check.executeQuery();

            if (rs.next() && !"checked-in".equalsIgnoreCase(rs.getString("status")) && !"checked-out".equalsIgnoreCase(rs.getString("status"))) {
                PreparedStatement delete = conn.prepareStatement("DELETE FROM reservation WHERE reservationID=?");
                delete.setString(1, reservationID);
                int rows = delete.executeUpdate();
                message = (rows > 0) ? "Reservation deleted successfully." : "Delete failed.";
            } else {
                message = "Cannot delete a checked-in or completed reservation.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error deleting reservation: " + e.getMessage();
        }

        response.sendRedirect("viewReservation.jsp?status=all&msg=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}
