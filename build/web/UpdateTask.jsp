<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Update Task</title>

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
                <h2 class="mb-4"><i class="bi bi-pencil-square"></i> Update Task Status</h2>

                <form action="UpdateTaskServlet" method="post" class="bg-white p-4 rounded shadow-sm">
                    <!-- Task ID Dropdown -->
                    <div class="mb-3">
                        <label for="taskID" class="form-label">Select Task ID</label>
                        <select name="assignmentID" id="assignmentID" class="form-select" required>
                            <%
                                List<Map<String, String>> assignedTasks = (List<Map<String, String>>) request.getAttribute("assignedTasks");
                                if (assignedTasks != null && !assignedTasks.isEmpty()) {
                                    for (Map<String, String> assignment : assignedTasks) {
                                        String id = assignment.get("assignmentID");
                                        String taskName = assignment.get("taskName");
                                        String roomNo = assignment.get("roomNo");
                                        String status = assignment.get("status");
                            %>
                            <option value="<%= id%>" <%= "Done".equals(status) ? "selected" : ""%>>
                                <%= taskName%> - Room <%= roomNo%> (Status: <%= status%>)
                            </option>
                            <%
                                }
                            } else {
                            %>
                            <option disabled>No assigned tasks found</option>
                            <%
                                }
                            %>
                        </select>

                    </div>

                    <!-- Task Status -->
                    <div class="mb-3">
                        <label for="taskStatus" class="form-label">Task Status</label>
                        <select id="taskStatus" name="taskStatus" class="form-select">
                            <option value="Done">Done</option>
                            <option value="Not Done">Not Done</option>
                        </select>
                    </div>

                    <!-- Submit -->
                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-check-circle"></i> Update Task
                    </button>
                </form>

                <!-- Optional Message -->
                <%
                    String message = request.getParameter("message");
                    if (message != null) {
                %>
                <div class="alert alert-success mt-3">
                    <%= message%>
                </div>
                <%
                    }
                %>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
