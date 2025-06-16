<%-- 
    Document   : login
    Created on : 11 May 2025, 10:35:49 pm
    Author     : User
--%>

<%@ page session="true" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin Login</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body style=" background: linear-gradient(to bottom right, #800000, #A52A2A);">
        <%-- Notif if user deleted --%>
        <%
            String deletedParam = request.getParameter("deleted");
            if ("true".equals(deletedParam)) {
        %>
        <% if (request.getParameter("signup") != null) { %>
        <div class="alert alert-success mt-3">Account created! Please login.</div>
        <% } %>

        <div id="deleteAlert" class="alert alert-success alert-dismissible fade show" role="alert"
             style="position: fixed; top: 20px; right: 20px; z-index: 9999;">
            Your account has been deleted successfully.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <%
            }
        %>


        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card shadow">
                        <div class="card-body">
                            <h1 class="card-title text-center mb-4">HOTEL MANAGEMENT SYSTEM</h1>
                            <h3 class="card-title text-center mb-4">Welcome</h3>
                            <form method="post" action="loginAction.jsp">
                                <div class="mb-3">
                                    <label class="form-label">Username</label>
                                    <input type="text" name="username" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Password</label>
                                    <input type="password" name="password" class="form-control" required>
                                </div>
                                <div class="text-end">
                                    <a href="forgotPassword.jsp" class="text-decoration-none">Forgot password?</a>
                                </div>

                                <div class="d-grid">
                                    <input type="submit" class="btn btn-primary" value="Login">
                                </div>
                                <div class="text-center mt-3">
                                    <p>Don't have an account?</p>
                                    <a href="signup.jsp" class="btn btn-outline-primary">Sign Up as Admin</a>
                                </div>

                            </form>
                            <% if (request.getParameter("error") != null) { %>
                            <div class="alert alert-danger mt-3">Invalid credentials. Please try again.</div>
                            <% }%>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Auto-dismiss the alert after 3 seconds
            setTimeout(function () {
                var alertElement = document.getElementById('deleteAlert');
                if (alertElement) {
                    var alert = bootstrap.Alert.getOrCreateInstance(alertElement);
                    alert.close();
                }
            }, 3000);
        </script>

    </body>
</html>
