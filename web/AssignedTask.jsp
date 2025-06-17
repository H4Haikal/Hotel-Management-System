<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" import="java.util.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Assign Task</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Custom CSS -->
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
                <h2 class="mb-4"><i class="bi bi-person-plus"></i> Assign Task to Housekeeping Staff</h2>

                <form action="AssignTaskServlet" method="post" class="bg-white p-4 rounded shadow-sm">
                    <!-- Staff ID Dropdown -->
                    <div class="mb-3">
                        <label for="staffID" class="form-label">Select Staff</label>
                        <select name="staffID" class="form-select" required>
                            <%
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/hotel_management?serverTimezone=UTC&zeroDateTimeBehavior=CONVERT_TO_NULL", "root", "");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT staffID, staffName FROM Staff");

                                    while (rs.next()) {
                                        int id = rs.getInt("staffID");
                                        String name = rs.getString("staffName");
                            %>
                            <option value="<%=id%>"><%=name%> (ID: <%=id%>)</option>
                            <%
                                    }
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch (Exception e) {
                                    out.println("Failed to load staff list: " + e.getMessage());
                                }
                            %>
                        </select>
                    </div>

                    <!-- Room Number -->
                    <div class="mb-3">
                        <label for="roomNo" class="form-label">Select Room No</label>
                        <select name="roomNo" class="form-select" required>
                            <%
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection(
                                            "jdbc:mysql://localhost:3307/hotel_management?serverTimezone=UTC&zeroDateTimeBehavior=CONVERT_TO_NULL",
                                            "root", ""
                                    );
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT roomNo, roomType, roomStatus FROM Room");

                                    while (rs.next()) {
                                        int roomNo = rs.getInt("roomNo");
                                        String roomType = rs.getString("roomType");
                                        String roomStatus = rs.getString("roomStatus");
                            %>
                            <option value="<%=roomNo%>">
                                <%=roomNo%> - <%=roomType%> (<%=roomStatus%>)
                            </option>
                            <%
                                    }
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch (Exception e) {
                                    out.println("Failed to load room list: " + e.getMessage());
                                }
                            %>
                        </select>
                    </div>


                    <!-- Task Checkboxes -->
                    <div class="mb-3">
                        <label class="form-label">Select Task(s)</label><br>
                        <div class="form-check">
                            <%
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/hotel_management?serverTimezone=UTC&zeroDateTimeBehavior=CONVERT_TO_NULL", "root", "");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT taskID, taskName FROM HousekeepingTask");

                                    while (rs.next()) {
                                        String id = rs.getString("taskID");
                                        String name = rs.getString("taskName");
                            %>
                            <div class="form-check">
                                <input type="checkbox" name="taskID" value="<%=id%>" class="form-check-input" id="task_<%=id%>">
                                <label class="form-check-label" for="task_<%=id%>"><%=name%></label>
                            </div>
                            <%
                                    }
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch (Exception e) {
                                    out.println("Failed to load task list: " + e.getMessage());
                                }
                            %>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-send-check"></i> Assign Task
                    </button>
                </form>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
