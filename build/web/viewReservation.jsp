<%-- 
    Document   : viewReservation
    Created on : May 23, 2025, 6:04:02 PM
    Author     : wanersyadd
--%>

<%@page import="java.sql.*, java.text.SimpleDateFormat, hotel.management.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8" session="true"%>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String filter = request.getParameter("status"); // filter param for status
    String whereClause = "";
    if (filter != null && !filter.equals("all")) {
        whereClause = "WHERE status = ?";
    }

    String pageURL = "viewReservation.jsp" + (filter != null ? "?status=" + filter : "");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>View Reservations</title>

        <!-- Bootstrap CSS & Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link href="style.css" rel="stylesheet">

        <style>
            .main-content {
                margin-left: 250px;
                padding: 30px;
                background: #f8f9fa;
                min-height: 100vh;
            }
        </style>
    </head>
    <body>

        <%@ include file="include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container">
                <% if (request.getParameter("msg") != null) {%>
                <div class="alert alert-info alert-dismissible fade show" role="alert">
                    <%= request.getParameter("msg")%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% }%>

                <h2 class="mb-4"><i class="bi bi-table"></i> Reservation Records</h2>

                <!-- Filter Buttons -->
                <div class="mb-4">
                    <a href="viewReservation.jsp?status=all" class="btn btn-outline-dark me-2 <%= "all".equals(filter) || filter == null ? "active" : ""%>">
                        <i class="bi bi-list-ul"></i> All
                    </a>
                    <a href="viewReservation.jsp?status=pending" class="btn btn-outline-secondary me-2 <%= "pending".equals(filter) ? "active" : ""%>">
                        <i class="bi bi-hourglass-split"></i> Pending
                    </a>
                    <a href="viewReservation.jsp?status=checked-in" class="btn btn-outline-success me-2 <%= "checked-in".equals(filter) ? "active" : ""%>">
                        <i class="bi bi-door-open"></i> Checked-In
                    </a>
                    <a href="viewReservation.jsp?status=checked-out" class="btn btn-outline-danger me-2 <%= "checked-out".equals(filter) ? "active" : ""%>">
                        <i class="bi bi-door-closed"></i> Checked-Out
                    </a>
                </div>

                <!-- Reservation Table -->
                <table class="table table-bordered table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>Reservation ID</th>
                            <th>Guest ID</th>
                            <th>Check-In</th>
                            <th>Check-Out</th>
                            <th>Room Type</th>
                            <th>Room No</th>
                            <th>Status</th>
                            <th>Action</th> <%-- Newly added for Updating and deleting--%>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try (
                                    Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(
                                    "SELECT * FROM reservation " + whereClause + " ORDER BY checkInDate DESC"
                            )) {
                                if (!whereClause.isEmpty()) {
                                    ps.setString(1, filter);
                                }

                                ResultSet rs = ps.executeQuery();
                                SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");

                                boolean found = false;
                                while (rs.next()) {
                                    found = true;
                                    Timestamp checkIn = rs.getTimestamp("checkInDate");
                                    Timestamp checkOut = rs.getTimestamp("checkOutDate");
                        %>
                        <tr>
                            <td><%= rs.getString("reservationID")%></td>
                            <td><%= rs.getString("guestID")%></td>
                            <td><%= checkIn != null ? formatter.format(checkIn) : "N/A"%></td>
                            <td><%= checkOut != null ? formatter.format(checkOut) : "N/A"%></td>
                            <td><%= rs.getString("roomType")%></td>
                            <td><%= rs.getInt("roomNo")%></td>
                            <td><%= rs.getString("status")%></td>
                            <td>
                                <% String status = rs.getString("status"); %>
                                <% if (!"checked-in".equalsIgnoreCase(status) && !"checked-out".equalsIgnoreCase(status)) {%>
                                <a href="updateReservation.jsp?reservationID=<%= rs.getString("reservationID")%>" class="btn btn-sm btn-warning me-2">
                                    <i class="bi bi-pencil-square"></i> Edit
                                </a>
                                <form method="post" action="DeleteReservationServlet" style="display:inline;" onsubmit="return confirm('Delete this reservation?')">
                                    <input type="hidden" name="reservationID" value="<%= rs.getString("reservationID")%>">
                                    <button type="submit" class="btn btn-sm btn-danger">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                                <% } else { %>
                                <span class="text-muted">-</span>
                                <% } %>
                            </td>


                        </tr>
                        <%
                                }
                                if (!found) {
                                    out.println("<tr><td colspan='7' class='text-center text-muted'>No reservations found.</td></tr>");
                                }
                                rs.close();
                            } catch (Exception e) {
                                out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Bootstrap Bundle -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>
