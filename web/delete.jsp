<%-- 
    Document   : delete
    Created on : 11 May 2025, 11:01:02 pm
    Author     : User
--%>

<%@ page import="java.sql.*, hotel.management.DBConnection" %>
<%@ page session="true" %>
<%
    String admin = (String) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (request.getMethod().equals("POST")) {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement("DELETE FROM admin WHERE username=?");
            stmt.setString(1, admin);
            stmt.executeUpdate();
            session.invalidate();
            response.sendRedirect("login.jsp?deleted=true");
            return;
        } catch (Exception e) {
            out.println("Delete error: " + e.getMessage());
        }
    }
%>
<%
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Delete Admin</title>
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
            <h3>Delete Admin Account</h3>
            <p>Are you sure you want to delete your account?</p>
            <form method="post">
                <button type="submit" class="btn btn-danger">Yes, Delete</button>
                <% int id = Integer.parseInt(request.getParameter("id")); %>
                <a href="admin_info.jsp?id=<%= id%>" class="btn btn-secondary">Cancel</a>
            </form>
        </div>
    </body>
</html>