package hotel.management;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.sql.*;

@WebServlet("/CheckOutServlet")
public class CheckOutServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reservationID = request.getParameter("reservationID");
        String message;

        try (Connection conn = DBConnection.getConnection()) {

            // ✅ Step 1: Check reservation exists & is checked-in
            PreparedStatement checkStatus = conn.prepareStatement(
                    "SELECT roomNo FROM Reservation WHERE reservationID=? AND status='checked-in'"
            );
            checkStatus.setString(1, reservationID);
            ResultSet rs = checkStatus.executeQuery();

            if (!rs.next()) {
                message = "Error: Reservation not found or guest has not checked in.";
            } else {
                String roomNo = rs.getString("roomNo");

                // ✅ Step 2: Proceed to update reservation to checked-out
                Timestamp checkOutTime = new Timestamp(System.currentTimeMillis());

                PreparedStatement ps = conn.prepareStatement(
                        "UPDATE Reservation SET status='checked-out', checkOutDate=? WHERE reservationID=? AND status='checked-in'"
                );
                ps.setTimestamp(1, checkOutTime);
                ps.setString(2, reservationID);
                ps.executeUpdate();

                // ✅ Step 3: Update room status
                PreparedStatement ps2 = conn.prepareStatement(
                        "UPDATE Room SET roomStatus='available' WHERE roomNo=?"
                );
                ps2.setString(1, roomNo);
                ps2.executeUpdate();

                message = "Check-out successful!";
                ps.close();
                ps2.close();
            }

            rs.close();
            checkStatus.close();

        } catch (Exception e) {
            e.printStackTrace();
            message = "Check-out failed due to server error: " + e.getMessage();
        }

        request.setAttribute("message", message);
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }
}
