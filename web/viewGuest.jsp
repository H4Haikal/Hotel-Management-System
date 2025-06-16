<%-- 
    Document   : viewGuest
    Created on : 25 May 2025, 5:42:12 pm
    Author     : User
--%>

<%@page import="java.sql.*, hotel.management.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8" session="true"%>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String keyword = request.getParameter("search");
    String query = "SELECT g.guestID, g.guestName, g.guestAddr, g.guestPhone, g.guestEmail, "
            + "r.reservationID, r.roomNo, r.status "
            + "FROM guest g LEFT JOIN reservation r ON g.guestID = r.guestID";

    boolean hasSearch = keyword != null && !keyword.trim().isEmpty();
    if (hasSearch) {
        query += " WHERE g.guestName LIKE ? OR g.guestEmail LIKE ?";
    }

    query += " ORDER BY g.guestID ASC";
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>View Guests with Reservation Info</title>

        <!-- Bootstrap CSS & Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link href="style.css" rel="stylesheet">

        <style>
            .main-content {
                margin-left: 250px;
                padding: 30px;
                background-color: #f8f9fa;
                min-height: 100vh;
            }
        </style>
    </head>
    <body>

        <%@ include file="include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container">
                <h2 class="mb-4"><i class="bi bi-people"></i> Guest List & Reservation Info</h2>

                <!-- Search Form -->
                <form class="d-flex mb-3" method="get" action="viewGuest.jsp">
                    <input class="form-control me-2" type="search" name="search" placeholder="Search by name or email" value="<%= keyword != null ? keyword : ""%>">
                    <button class="btn btn-outline-primary" type="submit">
                        <i class="bi bi-search"></i> Search
                    </button>
                </form>

                <!-- Guest + Reservation Table -->
                <table class="table table-bordered table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>Guest ID</th>
                            <th>Name</th>
                            <th>Address</th>
                            <th>Phone</th>
                            <th>Email</th>
                            <th>Reservation ID</th>
                            <th>Room No</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try (
                                    Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
                                if (hasSearch) {
                                    String like = "%" + keyword + "%";
                                    ps.setString(1, like);
                                    ps.setString(2, like);
                                }

                                ResultSet rs = ps.executeQuery();
                                boolean found = false;

                                while (rs.next()) {
                                    found = true;
                        %>
                        <tr>
                            <td><%= rs.getString("guestID")%></td>
                            <td><%= rs.getString("guestName")%></td>
                            <td><%= rs.getString("guestAddr")%></td>
                            <td><%= rs.getString("guestPhone")%></td>
                            <td><%= rs.getString("guestEmail")%></td>
                            <td><%= rs.getString("reservationID") != null ? rs.getString("reservationID") : "<span class='text-muted'>No reservation</span>"%></td>
                            <td><%= rs.getString("roomNo") != null ? rs.getString("roomNo") : "-"%></td>
                            <td><%= rs.getString("status") != null ? rs.getString("status") : "-"%></td>
                        </tr>
                        <%
                                }

                                if (!found) {
                                    out.println("<tr><td colspan='8' class='text-center text-muted'>No guests found.</td></tr>");
                                }

                                rs.close();
                            } catch (Exception e) {
                                out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>
