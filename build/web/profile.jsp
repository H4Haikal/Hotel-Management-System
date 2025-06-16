<%@ page import="java.sql.*, hotel.management.DBConnection" %>
<%@ page session="true" %>
<%
    String admin = (String) session.getAttribute("admin");

    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    ResultSet rs = null;
    Connection conn = null;
    PreparedStatement stmt = null;

    String adminFullName = "";
    int adminID = 0;

    try {
        conn = DBConnection.getConnection();
        stmt = conn.prepareStatement("SELECT * FROM admin WHERE username = ?");
        stmt.setString(1, admin);
        rs = stmt.executeQuery();

        if (rs.next()) {
            adminID = rs.getInt("admin_id");
            adminFullName = rs.getString("fullname"); // Use full name if available
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin Profile</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            .main-content {
                margin-left: 250px;
                padding: 30px;
                background-color: #f8f9fa;
                min-height: 100vh;
            }
            .profile-card {
                max-width: 500px;
                margin: auto;
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container">
                <h2 class="mb-4"><i class="bi bi-person-circle"></i> Admin Profile</h2>

                <div class="card shadow-sm profile-card">
                    <div class="card-body text-center">
                        <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" 
                             class="rounded-circle mb-3" width="100" alt="Profile Picture">

                        <h4 class="card-title"><%= adminFullName %></h4>
                        <p class="text-muted mb-2">Username: <span class="badge bg-secondary"><%= admin %></span></p>
                        <p class="text-success"><i class="bi bi-shield-lock-fill"></i> Logged in as Admin</p>

                        <div class="d-flex justify-content-center gap-2 mt-3">
                            <a href="admin_info.jsp?id=<%= adminID %>" class="btn btn-outline-primary">
                                <i class="bi bi-info-circle"></i> View Info
                            </a>
                            <a href="report.jsp" class="btn btn-outline-success">
                                <i class="bi bi-bar-chart-fill"></i> Reports
                            </a>
                            <a href="LogoutServlet" class="btn btn-outline-danger">
                                <i class="bi bi-box-arrow-right"></i> Logout
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>
