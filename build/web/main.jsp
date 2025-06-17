<%-- 
    Document   : main
    Created on : 29 Apr 2025, 2:50:17 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hotel Management - Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="style.css" rel="stylesheet">
        <style>
            .main-content {
                margin-left: 250px;
                padding: 20px;
            }

            .card-hover:hover {
                transform: scale(1.01);
                box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
                transition: all 0.3s ease;
            }

            .list-group-item:hover {
                background-color: #f0f0f0;
                transition: background-color 0.3s ease;
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="include/sidebar.jsp" %>

        <div class="container py-4" style="margin-left: 250px;"> <!-- Push content next to sidebar -->
            <div class="card shadow-sm">
                <div class="card-body">
                    <h2 class="card-title mb-3">Welcome to Our Hotel</h2>
                    <p class="card-text">We are dedicated to providing an unforgettable hospitality experience with exceptional service, comfort, and style. Our mission is to make every guest feel at home, with a focus on attention to detail and personalized care.</p>
                    <p class="card-text">Whether you're here for business, a vacation, or a special event, we ensure a relaxing and memorable stay. Our hotel offers modern amenities, spacious rooms, and a variety of services tailored to your needs. Let us help make your stay truly special.</p>

                    <h5 class="mt-4">Our values:</h5>
                    <ul class="list-group list-group-flush mb-4">
                        <li class="list-group-item">Excellence in service</li>
                        <li class="list-group-item">Commitment to quality</li>
                        <li class="list-group-item">Hospitality with a personal touch</li>
                        <li class="list-group-item">Creating lasting memories for our guests</li>
                    </ul>

                    <div class="text-center my-4">
                        <img src="https://i.pinimg.com/originals/5b/86/d0/5b86d0bf45d9a77e007b1eefe9050404.jpg" 
                             alt="Hotel Image" 
                             class="img-fluid rounded-5 shadow-lg border border-light"
                             style="max-height: 450px; object-fit: cover;">
                    </div>

                </div>
            </div>
        </div>
        <div class="main-content">
            <h4 class="">Quick Shortcuts</h4>
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <a href="checkin.jsp" class="text-decoration-none">
                        <div class="card text-center card-hover p-3">
                            <i class="fas fa-sign-in-alt fa-2x mb-2 text-primary"></i>
                            <h6>Check-In</h6>
                        </div>
                    </a>
                </div>
                <div class="col-md-3">
                    <a href="checkout.jsp" class="text-decoration-none">
                        <div class="card text-center card-hover p-3">
                            <i class="fas fa-sign-out-alt fa-2x mb-2 text-danger"></i>
                            <h6>Check-Out</h6>
                        </div>
                    </a>
                </div>
                <div class="col-md-3">
                    <a href="ReservationDashboard.jsp" class="text-decoration-none">
                        <div class="card text-center card-hover p-3">
                            <i class="fas fa-calendar-plus fa-2x mb-2 text-success"></i>
                            <h6>Reservation</h6>
                        </div>
                    </a>
                </div>
                <div class="col-md-3">
                    <a href="billDashboard.jsp" class="text-decoration-none">
                        <div class="card text-center card-hover p-3">
                            <i class="fas fa-credit-card fa-2x mb-2 text-warning"></i>
                            <h6>Payments</h6>
                        </div>
                    </a>
                </div>
                <div class="col-md-3">
                    <a href="HKDashboard.jsp" class="text-decoration-none">
                        <div class="card text-center card-hover p-3">
                            <i class="fas fa-broom fa-2x mb-2 text-success"></i>
                            <h6>Housekeeping</h6>
                        </div>
                    </a>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

</html>
