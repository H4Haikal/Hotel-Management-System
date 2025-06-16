<%-- 
    Document   : add
    Created on : 11 May 2025, 11:01:43 pm
    Author     : User
--%>

<%@ page import="java.sql.*, hotel.management.DBConnection" %>
<%@ page session="true" %>
<%
    String admin = (String) session.getAttribute("admin");
//    if (admin == null) {
//        response.sendRedirect("login.jsp");
//        return;
//    }

    if (request.getMethod().equals("POST")) {
        String newUsername = request.getParameter("username");
        String newPassword = request.getParameter("password");
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement("INSERT INTO admin (username, password) VALUES (?, ?)");
            stmt.setString(1, newUsername);
            stmt.setString(2, newPassword);
            stmt.executeUpdate();
            response.sendRedirect("profile.jsp");
            return;
        } catch (Exception e) {
            out.println("Add error: " + e.getMessage());
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Add New Admin</title>
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
            <h3>Add New Admin</h3>
            <form method="post">
                <div class="mb-3">
                    <label>Username</label>
                    <input type="text" name="username" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-success">Add Admin</button>
                <a href="profile.jsp" class="btn btn-sm btn-primary me-2">Back</a>
            </form>
        </div>
    </body>
</html>

