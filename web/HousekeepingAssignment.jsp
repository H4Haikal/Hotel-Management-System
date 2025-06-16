<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" import="java.util.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Housekeeping Assignments</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Optional Custom CSS -->
        <link rel="stylesheet" href="Housekeeping.css"/>

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
                <h2 class="mb-4"><i class="bi bi-list-task"></i> Housekeeping Assignments</h2>

                <div class="table-responsive">
                    <table class="table table-bordered table-striped table-hover bg-white shadow-sm">
                        <thead class="table-dark">
                            <tr>
                                <th>Assignment ID</th>
                                <th>Staff ID</th>
                                <th>Room Assigned</th>
                                <th>Task ID</th>
                                <th>Task Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/hotel_management?serverTimezone=UTC&zeroDateTimeBehavior=CONVERT_TO_NULL","root","");
                                    String sql = "SELECT ha.assignmentID, ha.housekeepingStaffID, ha.roomAssigned, at.taskID, at.taskStatus "
                                            + "FROM HousekeepingAssignment ha "
                                            + "JOIN AssignedTask at ON ha.assignmentID = at.assignmentID "
                                            + "JOIN Staff s ON ha.housekeepingStaffID = s.staffID";

                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery(sql);

                                    while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getInt("assignmentID")%></td>
                                <td><%= rs.getInt("housekeepingStaffID")%></td>
                                <td><%= rs.getInt("roomAssigned")%></td>
                                <td><%= rs.getString("taskID")%></td>
                                <td><%= rs.getString("taskStatus")%></td>
                            </tr>
                            <%
                                }

                                rs.close();
                                stmt.close();
                                conn.close();
                            } catch (Exception e) {
                            %>
                            <tr>
                                <td colspan="5" class="text-danger">Error loading data: <%= e.getMessage()%></td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
