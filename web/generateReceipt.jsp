<%@page contentType="text/html" pageEncoding="UTF-8" language="Java"%>
<%@page import="java.util.List, HMS.Payment.PaymentDAO, HMS.Payment.Payment" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Bill Dashboard</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
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

        <%@ include file="include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container">

                <div class="mt-5">
                    <h3><i class="bi bi-printer"></i> Generate Receipt</h3>
                    <div class="row">
                        <%
                            try {
                                PaymentDAO dao = new PaymentDAO();
                                List<Payment> paidBills = dao.getAllPayments();
                                for (Payment p : paidBills) {
                                    if ("paid".equalsIgnoreCase(p.getStatus())) {
                        %>
                        <div class="col-md-6">
                            <div class="card mb-3 shadow-sm">
                                <div class="card-body">
                                    <h5 class="card-title">Bill ID: <%= p.getBillID()%></h5>
                                    <p class="card-text mb-1">Guest: <%= p.getGuestName()%></p>
                                    <p class="card-text mb-1">Reservation: <%= p.getReservationID()%></p>
                                    <p class="card-text mb-2">Amount: RM <%= String.format("%.2f", p.getTotalAmount())%></p>
                                    <a href="receiptView.jsp?billID=<%= p.getBillID()%>" class="btn btn-outline-primary">
                                        <i class="bi bi-receipt"></i> Generate Receipt
                                    </a>
                                </div>
                            </div>
                        </div>
                        <%     }
                            }
                        } catch (Exception e) {%>
                        <div class="alert alert-danger">Error loading paid bills: <%= e.getMessage()%></div>
                        <% }%>
                    </div>
                </div>
            </div>

            <a href="billDashboard.jsp" class="btn btn-outline-secondary mt-4">
                <i class="bi bi-arrow-left-circle"></i> Back
            </a>

        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
