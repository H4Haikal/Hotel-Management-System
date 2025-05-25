<%@ page import="java.sql.*, hotel.management.DBConnection" %>
<%@ page session="true" %>
<%
    // Get admin username from session
    String admin = (String) session.getAttribute("admin");

    // For development/testing: fallback if session is not set
    if (admin == null) {
        admin = "Haikal1"; // Replace with a valid username in your DB
        // response.sendRedirect("login.jsp"); return; // enable when login is ready
    }

    // Prepare to get all admins
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
            adminFullName = rs.getString("username"); // Or replace with full name column if available
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
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
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin Profile</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="style.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
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
            <h3>Admin Profile</h3>

            <p><strong>Logged in as:</strong> <%= admin%></p>
            <br>

            <div class="d-flex justify-content-center">
                <div class="card mb-4" style="max-width: 400px; width: 100%;">
                    <div class="row g-0">
                        <div class="col-md-4 d-flex align-items-center justify-content-center">
                            <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" 
                                 alt="Profile Icon" class="img-fluid rounded-circle p-2" style="max-width: 80px;">
                        </div>
                        <div class="col-md-8">
                            <div class="card-body">
                                <h5 class="card-title mb-1">Welcome, <%= adminFullName%>!</h5>
                                <p class="card-text"><small class="text-muted">Logged in as Admin</small></p>
                                <a href="admin_info.jsp?id=<%= adminID%>" class="btn btn-sm btn-primary">View Info</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <a href="add.jsp" class="btn btn-success"><i class="bi bi-person-plus"></i>      <!-- Plus with person --></a>
<!--            <button onclick="window.print()" class="btn btn-secondary">Generate Report</button>-->
        </div>
    </body>
</html>
