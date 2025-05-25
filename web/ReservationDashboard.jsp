<%-- 
    Document   : ReservationDashboard
    Created on : 25 May 2025, 5:30:07 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" language="Java"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Reservation Dashboard</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Custom Styles -->
        <link href="style.css" rel="stylesheet">

        <style>
            .main-content {
                margin-left: 250px;
                padding: 30px;
                background: #f8f9fa;
                min-height: 100vh;
            }

            .card-link {
                text-decoration: none;
                color: inherit;
                transition: background-color 0.3s ease;
            }

            .card-link:hover {
                background-color: #e9ecef;
            }
        </style>
    </head>
    <body>
        <% String msg = (String) request.getAttribute("message"); %>
        <% if (msg != null) {%>
        <div class="alert alert-info"><%= msg%></div>
        <% }%>

        <%@ include file="include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container">
                <h1 class="mb-4"><i class="bi bi-calendar-check"></i> Reservation Dashboard</h1>

                <div class="row g-4">
                    <div class="col-md-4">
                        <a href="reservationPage.jsp" class="card card-link shadow-sm p-3 text-center">
                            <i class="bi bi-calendar-plus fs-1 text-success"></i>
                            <h5 class="mt-3">Add Reservation</h5>
                        </a>
                    </div>
                    <div class="col-md-4">
                        <a href="viewReservation.jsp" class="card card-link shadow-sm p-3 text-center">
                            <i class="bi bi-table fs-1 text-primary"></i>
                            <h5 class="mt-3">View Reservations</h5>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
