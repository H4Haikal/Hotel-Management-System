<%@page import="java.time.temporal.ChronoUnit"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="HMS.Payment.PaymentDAO, HMS.Payment.PaymentItem, HMS.Payment.Payment" %>
<%@ page import="java.util.List" %>

<%
    String billIDParam = request.getParameter("billID");
    int billID = 0;
    String errorMessage = null;
    PaymentDAO dao = new PaymentDAO();
    Payment payment = null;
    List<PaymentItem> items = null;

    try {
        if (billIDParam == null || billIDParam.trim().isEmpty()) {
            errorMessage = "Missing billID parameter.";
        } else {
            billID = Integer.parseInt(billIDParam);
            payment = dao.getPaymentByBillID(billID);
            if (payment == null) {
                errorMessage = "Bill not found.";
            } else {
                dao.updateTotalAmount(billID);
                payment = dao.getPaymentByBillID(billID); // Refresh
                items = dao.getPaymentItems(billID);
            }
        }
    } catch (Exception e) {
        errorMessage = "Error loading bill: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Bill Details</title>
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
            .table th {
                background-color: #2980b9;
                color: white;
            }
            .info-table td {
                font-weight: bold;
                background-color: #f0f4f8;
            }
            .btn-custom {
                padding: 10px 18px;
                font-weight: bold;
                border-radius: 4px;
                display: inline-block;
            }
            .btn-back {
                background-color: #7f8c8d;
                color: white;
                text-decoration: none;
            }
            .btn-back:hover {
                background-color: #626f70;
            }
            .btn-update {
                background-color: #2980b9;
                color: white;
                text-decoration: none;
            }
            .btn-update:hover {
                background-color: #1c5980;
            }
            .remove-btn {
                background-color: #e74c3c;
                color: white;
                border: none;
                padding: 4px 8px;
                font-size: 14px;
                border-radius: 4px;
            }
            .remove-btn:hover {
                background-color: #c0392b;
            }
        </style>
    </head>
    <body>

        <%@ include file="include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container">
                <h1 class="mb-4"><i class="bi bi-receipt-cutoff"></i> Bill Details</h1>

                <% if (errorMessage != null) {%>
                <div class="alert alert-danger text-center"><%= errorMessage%></div>
                <% } else {%>

                <h4 class="mb-3 text-primary">Bill ID: <%= billID%></h4>

                <table class="table table-bordered info-table">
                    <tr><td>Guest Name</td><td><%= payment.getGuestName()%></td></tr>
                    <tr><td>Bill ID</td><td><%= payment.getBillID()%></td></tr>
                    <tr><td>Reservation ID</td><td><%= payment.getReservationID()%></td></tr>
                    <tr><td>Room No</td><td><%= payment.getRoomNo()%></td></tr>
                    <tr><td>Room Type</td><td><%= payment.getRoomType()%></td></tr>
                    <tr><td>Price per Night</td><td>RM <%= String.format("%.2f", payment.getRoomPrice())%></td></tr>
                    <tr><td>Status</td><td><%= payment.getStatus()%></td></tr>

                    <% if ("Card".equalsIgnoreCase(payment.getPaymentMethod()) && payment.getPaymentReference() != null) {%>
                    <tr><td>Payment Reference Number</td><td><%= payment.getPaymentReference()%></td></tr>
                    <% }%>

                    <tr><td>Payment Date</td><td><%= payment.getPaymentDate() != null ? payment.getPaymentDate() : "-"%></td></tr>
                    <tr><td>Payment Method</td><td><%= payment.getPaymentMethod() != null ? payment.getPaymentMethod() : "-"%></td></tr>
                </table>

                <h4 class="mt-4">Payment Details</h4>
                <table class="table table-hover table-bordered">
                    <thead>
                        <tr>
                            <th>Item Description</th>
                            <th>Amount (RM)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            long nights = 1;
                            if (payment.getCheckInDate() != null && payment.getCheckOutDate() != null) {
                                nights = ChronoUnit.DAYS.between(
                                        payment.getCheckInDate().toLocalDateTime().toLocalDate(),
                                        payment.getCheckOutDate().toLocalDateTime().toLocalDate()
                                );
                                if (nights <= 0) {
                                    nights = 1;
                                }
                            }
                            String roomRowDesc = payment.getRoomType() + " Room (" + nights + " night" + (nights > 1 ? "s" : "") + ")";
                        %>
                        <tr>
                            <td><%= roomRowDesc%></td>
                            <td>RM <%= String.format("%.2f", payment.getRoomTotal())%></td>
                        </tr>

                        <% if (items == null || items.isEmpty()) { %>
                        <tr><td colspan="2" class="text-center text-muted">No add-on items found.</td></tr>
                        <% } else {
                            for (PaymentItem item : items) {
                        %>
                        <tr>
                            <td>
                                <%= item.getItemDescription()%>
                                <form action="RemovePaymentItemServlet" method="post" style="display:inline;" onsubmit="return confirm('Remove this item?')">
                                    <input type="hidden" name="itemID" value="<%= item.getItemID()%>" />
                                    <input type="hidden" name="billID" value="<%= billID%>" />
                                    <button type="submit" class="btn btn-sm remove-btn ms-2">
                                        <i class="bi bi-x-circle"></i>
                                    </button>
                                </form>
                            </td>
                            <td>RM <%= String.format("%.2f", item.getItemAmount())%></td>
                        </tr>
                        <% }
                    }%>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th>Total</th>
                            <th>RM <%= String.format("%.2f", payment.getTotalAmount())%></th>
                        </tr>
                    </tfoot>
                </table>

                <a href="updatePayment.jsp?billID=<%= billID%>" class="btn btn-update btn-custom me-2">
                    <i class="bi bi-pencil-square"></i> Update Bill
                </a>
                <a href="listPayment.jsp" class="btn btn-back btn-custom">
                    <i class="bi bi-arrow-left"></i> Back to List
                </a>

                <% }%>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
