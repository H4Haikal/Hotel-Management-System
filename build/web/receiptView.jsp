<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="HMS.Payment.PaymentDAO, HMS.Payment.Payment, HMS.Payment.PaymentItem"%>
<%@page import="java.util.List, java.time.temporal.ChronoUnit"%>
<%
    // Redirect if user is not logged in as admin
    if (session.getAttribute("staffID") == null || session.getAttribute("staffName") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String staffID = session.getAttribute("staffID").toString();
    String staffName = session.getAttribute("staffName").toString();
%>

<%
    String billIDParam = request.getParameter("billID");
    Payment payment = null;
    List<PaymentItem> items = null;
    long nights = 1;
    if (billIDParam != null) {
        try {
            int billID = Integer.parseInt(billIDParam);
            PaymentDAO dao = new PaymentDAO();
            payment = dao.getPaymentByBillID(billID);
            items = dao.getPaymentItems(billID);
            if (payment.getCheckInDate() != null && payment.getCheckOutDate() != null) {
                nights = ChronoUnit.DAYS.between(
                        payment.getCheckInDate().toLocalDateTime().toLocalDate(),
                        payment.getCheckOutDate().toLocalDateTime().toLocalDate()
                );
                if (nights <= 0) {
                    nights = 1;
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
    }

    PaymentDAO dao = new PaymentDAO();
    List<Payment> unpaidBills = null;
    String selectedBillID = request.getParameter("billID");
    Payment selectedPayment = null;
    try {
        unpaidBills = dao.getAllPayments();
        if (selectedBillID != null) {
            int bid = Integer.parseInt(selectedBillID);
            for (Payment p : unpaidBills) {
                if (p.getBillID() == bid) {
                    selectedPayment = p;
                    break;
                }
            }
        }
    } catch (Exception e) {
        request.setAttribute("error", "Error loading bills: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Receipt View</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            .main-content {
                margin-left: 250px;
                padding: 30px;
                background: #f8f9fa;
                min-height: 100vh;
            }
            .receipt-box {
                max-width: 800px;
                margin: auto;
                padding: 30px;
                background: #fff;
                box-shadow: 0 0 10px rgba(0,0,0,.15);
                border-radius: 8px;
            }
            .receipt-title {
                font-size: 2rem;
                font-weight: bold;
                text-align: center;
                margin-bottom: 20px;
            }
            .table th, .table td {
                vertical-align: middle;
            }
            .btn-back {
                margin-top: 20px;
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container">
                <div class="receipt-box" id="receiptArea">
                    <% if (payment != null) {%>
                    <!-- Company Info -->
                    <div class="text-center mb-4">
                        <h4>FutureStay Hotel</h4>
                        <p>123 Jalan Kampus, 21030 Kuala Nerus, Terengganu</p>
                        <p>Tel: +60 9-123 4567 | Email: support@futurestay.my</p>
                        <hr>
                    </div>

                    <!-- Receipt Info -->
                    <div class="mb-4">
                        <div class="d-flex justify-content-between">
                            <div>
                                <strong>Receipt ID:</strong> <%= "RCPT-" + payment.getBillID()%><br>
                                <strong>Reservation ID:</strong> <%= payment.getReservationID()%><br>
                                <strong>Guest Name:</strong> <%= payment.getGuestName()%><br>
                            </div>
                            <div class="text-end">
                                <strong>Staff In Charge:</strong><br>
                                Staff ID: <%= staffID != null ? staffID : "-"%><br>
                                Name: <%= staffName != null ? staffName : "-"%>
                            </div>
                        </div>
                    </div>

                    <hr>
                    <div class="table-responsive">
                        <table class="table table-sm table-bordered">
                            <thead class="table-light">
                                <tr><th>Description</th><th>Amount (RM)</th></tr>
                            </thead>
                            <tbody>
                                <%
                                    if (selectedPayment != null) {
                                        List<PaymentItem> itemSelected = dao.getPaymentItems(selectedPayment.getBillID());
                                        long night = 1;
                                        if (selectedPayment.getCheckInDate() != null && selectedPayment.getCheckOutDate() != null) {
                                            nights = ChronoUnit.DAYS.between(
                                                    selectedPayment.getCheckInDate().toLocalDateTime().toLocalDate(),
                                                    selectedPayment.getCheckOutDate().toLocalDateTime().toLocalDate()
                                            );
                                            if (night <= 0) {
                                                night = 1;
                                            }
                                        }
                                        String roomDesc = selectedPayment.getRoomType() + " Room (" + night + " night" + (night > 1 ? "s" : "") + ")";
                                        double roomTotal = selectedPayment.getRoomTotal();
                                        double addOnTotal = selectedPayment.getAddOnTotal();
                                        double total = roomTotal + addOnTotal;
                                %>
                                <tr><td><%= roomDesc%></td><td>RM <%= String.format("%.2f", roomTotal)%></td></tr>
                                <% for (PaymentItem item : itemSelected) {%>
                                <tr><td><%= item.getItemDescription()%></td><td>RM <%= String.format("%.2f", item.getItemAmount())%></td></tr>
                                <% }%>
                                <tr class="table-light"><th>Total</th><th>RM <%= String.format("%.2f", total)%></th></tr>
                                        <% } %>
                            </tbody>
                        </table>
                    </div>



                </div>
                <a href="generateReceipt.jsp" class="btn btn-outline-secondary btn-back">
                    <i class="bi bi-arrow-left-circle"></i> Back to Receipt List
                </a>
                <% } else { %>
                <div class="alert alert-warning">Invalid or missing Bill ID.</div>
                <a href="generateReceipt.jsp" class="btn btn-outline-secondary btn-back">
                    <i class="bi bi-arrow-left-circle"></i> Back to Receipt List
                </a>
                <% }%>
                <button class="btn btn-danger mt-3" onclick="downloadPDF()">
                    <i class="bi bi-file-earmark-pdf"></i> Download as PDF
                </button>

            </div>
        </div>
        <script>
            function downloadPDF() {
                const element = document.getElementById("receiptArea");

                const opt = {
                    margin: 0.5,
                    filename: 'Receipt_Bill_<%= payment.getBillID()%>.pdf',
                    image: {type: 'jpeg', quality: 0.98},
                    html2canvas: {scale: 2},
                    jsPDF: {unit: 'in', format: 'a4', orientation: 'portrait'}
                };

                html2pdf().set(opt).from(element).save();
            }
        </script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
