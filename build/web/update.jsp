<%@ page import="java.sql.*, hotel.management.DBConnection" %>
<%
    String idParam = request.getParameter("id");
    int id = 0;
    String username = "";
    String password = "";
    String course = "";
    String student_id = "";
    String email = "";
    String message = "";

    if (idParam != null) {
        id = Integer.parseInt(idParam);
    }

    // Handle form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newUsername = request.getParameter("username");
        String newPassword = request.getParameter("password");
        String newCourse = request.getParameter("course");
        String newStudentId = request.getParameter("student_id");
        String newEmail = request.getParameter("email");

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(
                "UPDATE admin SET username = ?, password = ?, course = ?, student_id = ?, email = ? WHERE admin_id = ?");
            stmt.setString(1, newUsername);
            stmt.setString(2, newPassword);
            stmt.setString(3, newCourse);
            stmt.setString(4, newStudentId);
            stmt.setString(5, newEmail);
            stmt.setInt(6, id);

            int updated = stmt.executeUpdate();
            stmt.close();
            conn.close();

            if (updated > 0) {
                // Reload updated data
                username = newUsername;
                password = newPassword;
                course = newCourse;
                student_id = newStudentId;
                email = newEmail;
                message = "<div class='alert alert-success'>Admin info updated successfully!</div>";
            } else {
                message = "<div class='alert alert-danger'>Update failed.</div>";
            }
        } catch (Exception e) {
            message = "<div class='alert alert-danger'>Error updating admin: " + e.getMessage() + "</div>";
        }
    } 

    // If not POST or no update success yet, load current data from DB
    if (!"POST".equalsIgnoreCase(request.getMethod()) || message.contains("failed") || message.contains("Error")) {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM admin WHERE admin_id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
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

    // Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
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
        
        <%= message %>

        <form method="post" action="update.jsp?id=<%= id %>">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" id="username" name="username" class="form-control" value="<%= username %>" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="text" id="password" name="password" class="form-control" value="<%= password %>" required>
            </div>
            <div class="mb-3">
                <label for="course" class="form-label">Course</label>
                <input type="text" id="course" name="course" class="form-control" value="<%= course %>" required>
            </div>
            <div class="mb-3">
                <label for="student_id" class="form-label">Student ID</label>
                <input type="text" id="student_id" name="student_id" class="form-control" value="<%= student_id %>" required>
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" id="email" name="email" class="form-control" value="<%= email %>" required>
            </div>

            <button type="submit" class="btn btn-primary">Update</button>
            <a href="admin_info.jsp?id=<%= id %>" class="btn btn-secondary ms-2">Back</a>
        </form>
    </div>
</body>
</html>
