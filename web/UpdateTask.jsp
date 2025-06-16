<%@ page import="hotel.management.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String adminUsername = (String) session.getAttribute("admin");
    if (adminUsername == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int adminID = (Integer) session.getAttribute("staffID");
    String adminName = (String) session.getAttribute("staffName");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Update Housekeeping Task</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="Housekeeping.css">
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

        <jsp:include page="include/sidebar.jsp" />

        <div class="main-content">
            <div class="container">
                <h2 class="mb-4">Update Housekeeping Task Status</h2>
                <p>Welcome, <strong><%= adminName%></strong></p>

                <%
                    HKDAO dao = new HKDAO();
                    List<AssignTask> assignedTasks = dao.getAllAssignedTasks();
                    if (assignedTasks == null || assignedTasks.isEmpty()) {
                %>
                <div class="alert alert-warning">No assigned tasks found.</div>
                <%
                } else {
                %>

                <table class="table table-bordered table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>Assignment ID</th>
                            <th>Room No</th>
                            <th>Task</th>
                            <th>Current Status</th>
                            <th>Update Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (AssignTask task : assignedTasks) {
                        %>
                        <tr>
                            <td class="align-middle"><%= task.getAssignmentID()%></td>
                            <td class="align-middle"><%= task.getRoomNo()%></td>
                            <td class="align-middle"><%= task.getTaskName()%></td>
                            <td class="align-middle"><%= task.getStatus()%></td>
                            <td class="align-middle">
                                <form action="SubmitTaskStatusServlet" method="post" class="d-flex">
                                    <input type="hidden" name="assignmentID" value="<%= task.getAssignmentID()%>">
                                    <select name="taskStatus" class="form-select me-2">
                                        <option value="NOT DONE" <%= task.getStatus().equals("NOT DONE") ? "selected" : ""%>>NOT DONE</option>
                                        <option value="DONE" <%= task.getStatus().equals("DONE") ? "selected" : ""%>>DONE</option>
                                    </select>
                            </td>
                            <td class="align-middle">
                                <button type="submit" class="btn btn-sm btn-success">
                                    <i class="bi bi-check2-circle"></i> Save
                                </button>
                                </form>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>

                <%
                    }
                %>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
