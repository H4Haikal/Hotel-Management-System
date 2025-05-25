<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- Font Awesome CDN -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">


<style>
    .sidebar {
        min-height: 100vh;
        position: fixed;
        top: 0;
        left: 0;
        width: 250px;
        background-color: #800000; /* Deep Maroon Red */
        padding-top: 20px;
    }

    .sidebar a {
        color: #fff;
        padding: 15px 20px;
        text-decoration: none;
        display: flex;
        align-items: center;
        font-size: 16px;
    }

    .sidebar a:hover {
        background-color: #B22222; /* Firebrick Red on hover */
    }

    .sidebar a i {
        margin-right: 10px;
        width: 20px;
        text-align: center;
    }
</style>


<div class="sidebar">
    <h2 class="text-white text-center">Hotel Management</h2>
    <a href="main.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
    <a href="checkin.jsp"><i class="bi bi-door-open"></i> Check-In</a>
    <a href="checkout.jsp"><i class="bi bi-door-closed"></i> Check-Out</a>
    <a href="ReservationDashboard.jsp"><i class="fas fa-calendar-plus"></i>Reservation</a>
    <a href="roomDashboard.jsp"><i class="fas fa-bed"></i> View Rooms</a> <!-- Added this line -->
    <a href="viewGuest.jsp"><i class="fas fa-users"></i> View Guests</a>
    <a href="viewPayments.jsp"><i class="fas fa-credit-card"></i> Payments</a>
    <a href="HKDashboard.jsp"><i class="fas fa-broom"></i> Housekeeping</a>
    <a href="report.jsp"><i class="fas fa-file-alt"></i> Reports</a>
    <a href="profile.jsp"><i class="fas fa-user"></i> Profile</a>
    <a href="LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>
