<%@ page import="java.sql.*, hotel.management.DBConnection" %>
<%@ page session="true" %>

<%
    String admin = (String) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get admin ID from URL parameter
    String idParam = request.getParameter("id");
    int adminID = 0;

    try {
        if (idParam != null) {
            adminID = Integer.parseInt(idParam);
        } else {
            out.println("<div class='alert alert-danger'>No admin ID provided.</div>");
            return;
        }
    } catch (NumberFormatException e) {
        out.println("<div class='alert alert-danger'>Invalid admin ID.</div>");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement("DELETE FROM admin WHERE admin_id=?");
            stmt.setInt(1, adminID);
            stmt.executeUpdate();

            session.invalidate(); // logout the user
            response.sendRedirect("login.jsp?deleted=true");
            return;

        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Delete error: " + e.getMessage() + "</div>");
        }
    }
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
                <input type="hidden" name="id" value="<%= adminID%>"/>
                <button type="submit" class="btn btn-danger">Yes, Delete</button>
                <a href="admin_info.jsp?id=<%= adminID%>" class="btn btn-secondary">Cancel</a>
            </form>
        </div>
    </body>
</html>
