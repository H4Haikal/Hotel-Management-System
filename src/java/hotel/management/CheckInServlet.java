/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package hotel.management;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.sql.*;

@WebServlet("/CheckInServlet")
public class CheckInServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reservationID = request.getParameter("reservationID");
        String message;

        try (Connection conn = DBConnection.getConnection()) {

            Timestamp checkInTime = new Timestamp(System.currentTimeMillis());

            // Update reservation status and check-in date
            PreparedStatement ps = conn.prepareStatement(
                    "UPDATE Reservation SET status='checked-in', checkInDate=? WHERE reservationID=? AND status='pending'"
            );
            ps.setTimestamp(1, checkInTime);
            ps.setString(2, reservationID);
            int updated = ps.executeUpdate();

            if (updated > 0) {
                PreparedStatement ps2 = conn.prepareStatement(
                        "UPDATE Room SET roomStatus='occupied' WHERE roomNo=(SELECT roomNo FROM Reservation WHERE reservationID=?)"
                );
                ps2.setString(1, reservationID);
                ps2.executeUpdate();

                message = "Check-in completed successfully!";
            } else {
                message = "Error: Reservation ID not found.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Check-in failed due to server error.";
        }

        request.setAttribute("message", message);
        request.getRequestDispatcher("checkin.jsp").forward(request, response);
    }
}
