/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package hotel.management;

import java.io.IOException;
import java.io.PrintWriter;
import static java.lang.System.out;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author User
 */
@WebServlet("/AddReservation") 
public class AddReservation extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String guestName = request.getParameter("guestName");
        String guestEmail = request.getParameter("guestEmail");
        String guestPhone = request.getParameter("guestPhone");
        String checkInDate = request.getParameter("checkInDate");
        String checkOutDate = request.getParameter("checkOutDate");
        String roomType = request.getParameter("roomType");
        
        try {
            Connection conn = DBConnection.getConnection();
            
            // First insert guest information
            String guestSql = "INSERT INTO Guest (guestName, guestEmail, guestPhone) VALUES (?, ?, ?)";
            PreparedStatement guestStmt = conn.prepareStatement(guestSql, Statement.RETURN_GENERATED_KEYS);
            guestStmt.setString(1, guestName);
            guestStmt.setString(2, guestEmail);
            guestStmt.setString(3, guestPhone);
            guestStmt.executeUpdate();
            
            // Get the generated guestID
            ResultSet rs = guestStmt.getGeneratedKeys();
            int guestID = 0;
            if (rs.next()) {
                guestID = rs.getInt(1);
            }
            
            // Then insert reservation
            String reservationSql = "INSERT INTO Reservation (guestID, checkInDate, checkOutDate, roomType, status) VALUES (?, ?, ?, ?, 'Pending')";
            PreparedStatement reservationStmt = conn.prepareStatement(reservationSql);
            reservationStmt.setInt(1, guestID);
            reservationStmt.setString(2, checkInDate);
            reservationStmt.setString(3, checkOutDate);
            reservationStmt.setString(4, roomType);
            reservationStmt.executeUpdate();
            
            response.sendRedirect("reservation_success.jsp");
            
        } catch (Exception e) {
            e.printStackTrace(out);
            response.sendRedirect("reservationPage.jsp");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
