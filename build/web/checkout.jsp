<%-- 
    Document   : checkout
    Created on : 29 Apr 2025, 2:30:11 pm
    Author     : User
--%>

<%@page import="java.sql.*, hotel.management.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Check-Out</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="style.css" rel="stylesheet">
        <style>
            .main-content {
                margin-left: 250px;
                padding: 20px;
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="include/sidebar.jsp" %>

        <div class="main-content">
            <h2 class="mb-4">Guest Check-Out</h2>

            <!-- Check-Out Form -->
            <form action="CheckOutServlet" method="post">
                <div class="mb-3">
                    <label class="form-label">Reservation ID:</label>
                    <input type="text" name="reservationID" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary">Check Out</button>

                <!-- Show Message -->
                <% String msg = (String) request.getAttribute("message");
                    if (msg != null) {%>
                <div class="alert alert-info alert-dismissible fade show mt-3" role="alert">
                    <%= msg%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>
            </form>

            <!-- Checked-In Reservations Table -->
            <hr class="my-4">
            <h4>Currently Checked-In Guests</h4>
            <table class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>Reservation ID</th>
                        <th>Guest ID</th>
                        <th>Check-In</th>
                        <th>Check-Out</th>
                        <th>Room No</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Connection conn = DBConnection.getConnection();
                            PreparedStatement ps = conn.prepareStatement(
                                    "SELECT * FROM Reservation WHERE status='checked-in'"
                            );
                            ResultSet rs = ps.executeQuery();

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("reservationID")%></td>
                        <td><%= rs.getString("guestID")%></td>
                        <%
                            java.sql.Timestamp checkIn = rs.getTimestamp("checkInDate");
                            java.sql.Timestamp checkOut = rs.getTimestamp("checkOutDate");
                            java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        %>
                        <td><%= (checkIn != null) ? formatter.format(checkIn) : "TBD" %></td>
                        <td><%= (checkOut != null) ? formatter.format(checkOut) : "TBD" %></td>
                        <td><%= rs.getString("roomNo")%></td>
                        <td><%= rs.getString("status")%></td>
                    </tr>
                    <%
                            }
                            rs.close();
                            ps.close();
                            conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6'>Error loading reservations: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>
                <br><br><!-- Check out table -->
            <h4>Checked Out Guests</h4>
            <table class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>Reservation ID</th>
                        <th>Guest ID</th>
                        <th>Check-In</th>
                        <th>Check-Out</th>
                        <th>Room No</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Connection conn = DBConnection.getConnection();
                            PreparedStatement ps = conn.prepareStatement(
                                    "SELECT * FROM Reservation WHERE status='checked-out'"
                            );
                            ResultSet rs = ps.executeQuery();

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("reservationID")%></td>
                        <td><%= rs.getString("guestID")%></td>
                        <%
                            java.sql.Timestamp checkIn = rs.getTimestamp("checkInDate");
                            java.sql.Timestamp checkOut = rs.getTimestamp("checkOutDate");
                            java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        %>
                        <td><%= (checkIn != null) ? formatter.format(checkIn) : "TBD" %></td>
                        <td><%= (checkOut != null) ? formatter.format(checkOut) : "TBD" %></td>
                        <td><%= rs.getString("roomNo")%></td>
                        <td><%= rs.getString("status")%></td>
                    </tr>
                    <%
                            }
                            rs.close();
                            ps.close();
                            conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6'>Error loading reservations: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>    
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

