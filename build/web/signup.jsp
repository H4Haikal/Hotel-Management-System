<%-- 
    Document   : signup.jsp
    Created on : 25 May 2025, 8:15:39 pm
    Author     : User
--%>
<%@ page import="java.sql.*, hotel.management.DBConnection" %>
<%@ page session="true" %>
<%
    if (request.getMethod().equals("POST")) {
        String newUsername = request.getParameter("username");
        String newPassword = request.getParameter("password");

        try {
            Connection conn = DBConnection.getConnection();

            // Check if username already exists
            PreparedStatement checkStmt = conn.prepareStatement("SELECT * FROM admin WHERE username = ?");
            checkStmt.setString(1, newUsername);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Username exists
                response.sendRedirect("signup.jsp?error=exists");
                return;
            }

            PreparedStatement stmt = conn.prepareStatement("INSERT INTO admin (username, password) VALUES (?, ?)");
            stmt.setString(1, newUsername);
            stmt.setString(2, newPassword); // ? You should hash this in real apps
            stmt.executeUpdate();
            response.sendRedirect("login.jsp?signup=success");
            return;
        } catch (Exception e) {
            out.println("Signup error: " + e.getMessage());
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin Sign Up</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body style="background: linear-gradient(to bottom right, #800000, #A52A2A);">
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card shadow">
                        <div class="card-body">
                            <h2 class="text-center mb-4">Sign Up as New Admin</h2>
                            <% if (request.getParameter("error") != null) { %>
                            <div class="alert alert-danger">Username already exists.</div>
                            <% }%>
                            <form method="post">
                                <div class="mb-3">
                                    <label class="form-label">Username</label>
                                    <input type="text" name="username" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Password</label>
                                    <input type="password" name="password" class="form-control" required>
                                </div>
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-success">Sign Up</button>
                                </div>
                                <div class="text-center mt-3">
                                    <a href="login.jsp" class="btn btn-sm btn-secondary">Back to Login</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
