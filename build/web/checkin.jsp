<%@page import="java.sql.*, hotel.management.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Show message if redirected with query param
    String message = request.getParameter("msg");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Check-In</title>
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
            <h2 class="mb-4">Guest Check-In</h2>

            <!-- Check-In Form -->
            <form action="CheckInServlet" method="post">
                <div class="mb-3">
                    <label class="form-label">Reservation ID:</label>
                    <input type="text" name="reservationID" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-success">Check In</button>

                <% if (message != null) {%>
                <div class="alert alert-info alert-dismissible fade show mt-3" role="alert">
                    <%= message%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>
            </form>

            <hr class="my-4">
            <h4>Pending Reservations</h4>
            <table class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>Reservation ID</th>
                        <th>Guest ID</th>
                        <th>Check-In</th>
                        <th>Check-Out</th>
                        <th>Room No</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Connection conn = DBConnection.getConnection();
                            PreparedStatement ps = conn.prepareStatement("SELECT * FROM Reservation WHERE status='pending'");
                            ResultSet rs = ps.executeQuery();
                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("reservationID")%></td>
                        <td><%= rs.getString("guestID")%></td>
                        <td><%= rs.getTimestamp("checkInDate") != null ? rs.getTimestamp("checkInDate") : "TBD"%></td>
                        <td><%= rs.getTimestamp("checkOutDate") != null ? rs.getTimestamp("checkOutDate") : "TBD"%></td>
                        <td><%= rs.getString("roomNo")%></td>
                        <td><%= rs.getString("status")%></td>
                        <td>
                            <form method="post" action="cancelPending.jsp" onsubmit="return confirm('Cancel this pending reservation?');">
                                <input type="hidden" name="reservationID" value="<%= rs.getString("reservationID")%>">
                                <input type="hidden" name="roomNo" value="<%= rs.getString("roomNo")%>">
                                <button type="submit" class="btn btn-sm btn-danger">Cancel</button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                            rs.close();
                            ps.close();
                            conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>

            <hr class="my-4">
            <h4>Currently Checked in Guests</h4>
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
                            PreparedStatement ps = conn.prepareStatement("SELECT * FROM Reservation WHERE status='checked-in'");
                            ResultSet rs = ps.executeQuery();
                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("reservationID")%></td>
                        <td><%= rs.getString("guestID")%></td>
                        <td><%= rs.getTimestamp("checkInDate") != null ? rs.getTimestamp("checkInDate") : "TBD"%></td>
                        <td><%= rs.getTimestamp("checkOutDate") != null ? rs.getTimestamp("checkOutDate") : "TBD"%></td>
                        <td><%= rs.getString("roomNo")%></td>
                        <td><%= rs.getString("status")%></td>
                    </tr>
                    <%
                            }
                            rs.close();
                            ps.close();
                            conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
