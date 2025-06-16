<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, java.time.temporal.ChronoUnit, HMS.Payment.PaymentDAO, HMS.Payment.Payment, HMS.Payment.PaymentItem"%>

<%
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
        <title>Update Payment</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            .main-content {
                margin-left: 250px;
                padding: 30px;
                background: #f8f9fa;
                min-height: 100vh;
            }
            .form-container {
                max-width: 600px;
                margin: 0 auto;
                background: #fff;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            .btn-back {
                background-color: #7f8c8d;
                color: white;
                padding: 10px 20px;
                border-radius: 4px;
                text-decoration: none;
                margin-top: 20px;
                display: inline-block;
            }
            .btn-back:hover {
                background-color: #626f70;
            }
            #cardRefBox {
                display: none;
            }
        </style>
    </head>
    <body>

        <%@ include file="include/sidebar.jsp" %>

        <div class="main-content">
            <div class="form-container">
                <form action="updatePayServlet" method="post">
                    <input type="hidden" name="billID" value="<%= selectedBillID%>" />

                    <div class="mb-3">
                        <label class="form-label">Bill ID:</label>
                        <input type="text" class="form-control" value="<%= selectedBillID%>" readonly />
                    </div>

                    <% if (selectedPayment != null) {%>
                    <div class="mb-3">
                        <label class="form-label">Guest Name:</label>
                        <input type="text" class="form-control" value="<%= selectedPayment.getGuestName()%>" readonly />
                    </div>
                    <% }%>

                    <!-- Payment Method -->
                    <div class="mb-3">
                        <label for="paymentMethod" class="form-label">Payment Method:</label>
                        <select name="paymentMethod" id="paymentMethod" class="form-select" required>
                            <option value="Cash" <%= "Cash".equalsIgnoreCase(selectedPayment.getPaymentMethod()) ? "selected" : ""%>>Cash</option>
                            <option value="Card" <%= "Card".equalsIgnoreCase(selectedPayment.getPaymentMethod()) ? "selected" : ""%>>Card</option>
                        </select>
                    </div>

                    <!-- Card Reference (shown only if method is Card) -->
                    <div id="cardRefBox" class="mb-3" 
                         style="<%= "Card".equalsIgnoreCase(selectedPayment.getPaymentMethod()) ? "" : "display:none;"%>">
                        <label for="cardRef" class="form-label">Payment Reference Number:</label>
                        <input type="text" class="form-control" id="cardRef" name="paymentReference"
                               value="<%= selectedPayment.getPaymentReference()%>"
                               placeholder="e.g. POS-123456789" />
                    </div>



                    <div class="mb-3">
                        <label for="paymentDate" class="form-label">Payment Date:</label>
                        <input type="date" class="form-control" name="paymentDate" id="paymentDate"
                               value="<%= selectedPayment.getPaymentDate() != null ? selectedPayment.getPaymentDate() : ""%>" required />
                    </div>

                    <h5><i class="bi bi-receipt"></i> Bill Breakdown</h5>
                    <div class="table-responsive">
                        <table class="table table-sm table-bordered">
                            <thead class="table-light">
                                <tr><th>Description</th><th>Amount (RM)</th></tr>
                            </thead>
                            <tbody>
                                <%
                                    if (selectedPayment != null) {
                                        List<PaymentItem> items = dao.getPaymentItems(selectedPayment.getBillID());
                                        long nights = 1;
                                        if (selectedPayment.getCheckInDate() != null && selectedPayment.getCheckOutDate() != null) {
                                            nights = ChronoUnit.DAYS.between(
                                                    selectedPayment.getCheckInDate().toLocalDateTime().toLocalDate(),
                                                    selectedPayment.getCheckOutDate().toLocalDateTime().toLocalDate()
                                            );
                                            if (nights <= 0) {
                                                nights = 1;
                                            }
                                        }
                                        String roomDesc = selectedPayment.getRoomType() + " Room (" + nights + " night" + (nights > 1 ? "s" : "") + ")";
                                        double roomTotal = selectedPayment.getRoomTotal();
                                        double addOnTotal = selectedPayment.getAddOnTotal();
                                        double total = roomTotal + addOnTotal;
                                %>
                                <tr><td><%= roomDesc%></td><td>RM <%= String.format("%.2f", roomTotal)%></td></tr>
                                <% for (PaymentItem item : items) {%>
                                <tr><td><%= item.getItemDescription()%></td><td>RM <%= String.format("%.2f", item.getItemAmount())%></td></tr>
                                <% }%>
                                <tr class="table-light"><th>Total</th><th>RM <%= String.format("%.2f", total)%></th></tr>
                                        <% }%>
                            </tbody>
                        </table>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 mt-3">Confirm Payment</button>
                </form>

                <a href="listPayment.jsp" class="btn btn-outline-secondary mt-4">
                    <i class="bi bi-arrow-left"></i> Back
                </a>
            </div>

        </div>
    </div>

    <script>
     window.addEventListener("DOMContentLoaded", function () {
         const methodSelect = document.getElementById("paymentMethod");
         const refBox = document.getElementById("cardRefBox");

         function toggleRefBox() {
             if (methodSelect.value === "Card") {
                 refBox.style.display = "block";
             } else {
                 refBox.style.display = "none";
                 document.getElementById("cardRef").value = ""; // Optional clear
             }
         }

         // Initial check on load
         toggleRefBox();

         // Listen for changes
         methodSelect.addEventListener("change", toggleRefBox);
     });
    </script>





</body>
</html>
