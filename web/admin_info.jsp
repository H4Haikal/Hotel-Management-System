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

    String username = "", password = "", fullname = "", position = "", email = "";

    if (rs.next()) {
        username = rs.getString("username");
        password = rs.getString("password");
        fullname = rs.getString("fullname");
        position = rs.getString("position");
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

    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
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
                    <label class="form-label">Username</label>
                    <input type="text" class="form-control" value="<%= username%>" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label">Full Name</label>
                    <input type="text" class="form-control" value="<%= fullname != null ? fullname : "-"%>" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <input type="password" class="form-control" value="<%= password%>" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label">Position</label>
                    <input type="text" class="form-control" value="<%= position != null ? position : "-"%>" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" value="<%= email != null ? email : "-"%>" readonly>
                </div>

                <a href="update.jsp?id=<%= id%>" class="btn btn-sm btn-warning me-2">Update</a>
                <a href="delete.jsp?id=<%= id%>" class="btn btn-sm btn-danger me-2">Delete</a>
                <a href="profile.jsp" class="btn btn-sm btn-primary me-2">Back</a>
            </form>
        </div>
    </body>
</html>


