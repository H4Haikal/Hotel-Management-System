<%@ page import="java.sql.*, hotel.management.DBConnection" %>
<%
    String idParam = request.getParameter("id");
    int id = 0;
    String username = "", password = "", fullname = "", position = "", email = "", message = "";

    if (idParam != null) {
        id = Integer.parseInt(idParam);
    }

    // Handle form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newUsername = request.getParameter("username");
        String newPassword = request.getParameter("password");
        String newFullname = request.getParameter("fullname");
        String newPosition = request.getParameter("position");
        String newEmail = request.getParameter("email");

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(
                    "UPDATE admin SET username = ?, password = ?, fullname = ?, position = ?, email = ? WHERE admin_id = ?");
            stmt.setString(1, newUsername);
            stmt.setString(2, newPassword);
            stmt.setString(3, newFullname);
            stmt.setString(4, newPosition);
            stmt.setString(5, newEmail);
            stmt.setInt(6, id);

            int updated = stmt.executeUpdate();
            stmt.close();
            conn.close();

            if (updated > 0) {
                username = newUsername;
                password = newPassword;
                fullname = newFullname;
                position = newPosition;
                email = newEmail;
                message = "<div class='alert alert-success'>Admin info updated successfully!</div>";
            } else {
                message = "<div class='alert alert-danger'>Update failed.</div>";
            }
        } catch (Exception e) {
            message = "<div class='alert alert-danger'>Error updating admin: " + e.getMessage() + "</div>";
        }
    }

    // Load current data from DB if GET or failed POST
    if (!"POST".equalsIgnoreCase(request.getMethod()) || message.contains("failed") || message.contains("Error")) {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM admin WHERE admin_id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
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
        } catch (Exception e) {
            message = "<div class='alert alert-danger'>Error loading admin data: " + e.getMessage() + "</div>";
        }
    }
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
        <title>Update Admin Info</title>
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
            <h1>Update Admin Info</h1>

            <%= message%>

            <form method="post" action="update.jsp?id=<%= id%>">
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" id="username" name="username" class="form-control" value="<%= username%>" required>
                </div>
                <div class="mb-3">
                    <label for="fullname" class="form-label">Full Name</label>
                    <input type="text" id="fullname" name="fullname" class="form-control" value="<%= fullname%>" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="text" id="password" name="password" class="form-control" value="<%= password%>" required>
                </div>
                <div class="mb-3">
                    <label for="position" class="form-label">Position</label>
                    <input type="text" id="position" name="position" class="form-control" value="<%= position%>" required>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" id="email" name="email" class="form-control" value="<%= email%>" required>
                </div>

                <button type="submit" class="btn btn-primary">Update</button>
                <a href="admin_info.jsp?id=<%= id%>" class="btn btn-secondary ms-2">Back</a>
            </form>
        </div>
    </body>
</html>

