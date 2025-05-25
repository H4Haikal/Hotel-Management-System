<%-- 
    Document   : admin_info
    Created on : 18 May 2025, 9:35:25 am
    Author     : User
--%>
<%@ page import="java.sql.*, hotel.management.DBConnection" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    Connection conn = DBConnection.getConnection();
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM admin WHERE admin_id = ?");
    ps.setInt(1, id);
    ResultSet rs = ps.executeQuery();

    String username = "";
    String password = "";
    String course = "";
    String student_id = "";
    String email = "";

    if (rs.next()) {
        username = rs.getString("username");
        password = rs.getString("password");
        course = rs.getString("course");
        student_id = rs.getString("student_id");
        email = rs.getString("email");
    }

    rs.close();
    ps.close();
    conn.close();
%>
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
<html>
    <head>
        <title>Admin Info</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="style.css" rel="stylesheet">
        <style>
            .main-content {
                margin-left: 250px;
                padding: 20px;
                max-width: 600px;
            }
            label {
                font-weight: 600;
            }
        </style>
    </head>
    <body class="bg-light p-4">
        <%@ include file="include/sidebar.jsp" %>
        <div class="main-content">
            <h1>Admin Info</h1>
            <form>
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" id="username" class="form-control" value="<%= username%>" readonly>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" class="form-control" value="<%= password%>" readonly>
                </div>
                <div class="mb-3">
                    <label for="course" class="form-label">Course</label>
                    <input type="text" id="course" class="form-control" value="<%= course%>" readonly>
                </div>
                <div class="mb-3">
                    <label for="student_id" class="form-label">Student ID</label>
                    <input type="text" id="student_id" class="form-control" value="<%= student_id%>" readonly>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" id="email" class="form-control" value="<%= email%>" readonly>
                </div>
                <a href="update.jsp?id=<%= id%>" class="btn btn-sm btn-warning me-2">Update</a>
                <a href="delete.jsp?id=<%= id%>" class="btn btn-sm btn-danger me-2">Delete</a>
                <a href="profile.jsp" class="btn btn-sm btn-primary me-2">Back</a>
            </form>
        </div>
    </body>
</html>
