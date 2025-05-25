<%-- 
    Document   : roomDashboard.jsp
    Created on : 25 May 2025, 8:35:44 pm
    Author     : User
--%>

<%@page import="java.sql.*, hotel.management.DBConnection" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Room Dashboard</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <!-- Custom Styles -->
        <link href="style.css" rel="stylesheet">

        <style>
            .main-content {
                margin-left: 250px;
                padding: 30px;
                background: #f8f9fa;
                min-height: 100vh;
            }

            .card-link {
                text-decoration: none;
                color: inherit;
                transition: background-color 0.3s ease;
            }

            .card-link:hover {
                background-color: #e9ecef;
            }
        </style>
    </head>
    <body>
        <%@ include file="include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container">
                <h1 class="mb-4"><i class="bi bi-door-open"></i> Room Dashboard</h1>

                <div class="mb-3">
                    <a href="addRoom.jsp" class="btn btn-success"><i class="bi bi-plus-circle"></i> Add New Room</a>
                </div>

                <table class="table table-striped table-bordered">
                    <thead class="table-dark">
                        <tr>
                            <th>Room No</th>
                            <th>Room Type</th>
                            <th>Room Price</th>
                            <th>Room Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            Connection conn = null;
                            PreparedStatement stmt = null;
                            ResultSet rs = null;

                            try {
                                conn = DBConnection.getConnection();
                                String sql = "SELECT * FROM room";
                                stmt = conn.prepareStatement(sql);
                                rs = stmt.executeQuery();

                                while (rs.next()) {
                        %>
                        <tr>
                            <td><%= rs.getInt("roomNo")%></td>
                            <td><%= rs.getString("roomType")%></td>
                            <td>RM <%= rs.getBigDecimal("roomPrice")%></td>
                            <td><%= rs.getString("roomStatus")%></td>
                        </tr>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='4' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                            } finally {
                                if (rs != null) try {
                                    rs.close();
                                } catch (Exception e) {
                                }
                                if (stmt != null) try {
                                    stmt.close();
                                } catch (Exception e) {
                                }
                                if (conn != null) try {
                                    conn.close();
                                } catch (Exception e) {
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
