<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="HMS.Payment.Payment, HMS.Payment.PaymentDAO"%>

<%
    PaymentDAO dao = new PaymentDAO();
    List<Payment> list = dao.getAllPayments();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Payment List</title>

        <!-- Bootstrap -->
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
            .status-paid {
                color: #27ae60;
                font-weight: bold;
            }
            .status-notpaid {
                color: #c0392b;
                font-weight: bold;
            }
            .bill-link {
                color: #2980b9;
                font-weight: 600;
                text-decoration: none;
            }
            .bill-link:hover {
                text-decoration: underline;
            }
            .no-data {
                text-align: center;
                padding: 30px;
                font-style: italic;
                color: #888;
            }
            .btn-back {
                background-color: #2980b9;
                color: white;
                border: none;
                padding: 10px 18px;
                font-weight: bold;
                border-radius: 4px;
                cursor: pointer;
            }
            .btn-back:hover {
                background-color: #1c5980;
            }
        </style>
    </head>
    <body>

        <%@ include file="include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container">
                <h1 class="mb-4"><i class="bi bi-receipt"></i> Payment Records</h1>

                <% if (list == null || list.isEmpty()) { %>
                <div class="alert alert-warning no-data">No payment records found.</div>
                <% } else { %>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover bg-white shadow-sm">
                        <thead class="table-primary">
                            <tr>
                                <th>Bill ID</th>
                                <th>Reservation</th>
                                <th>Guest</th>
                                <th>Room Type</th>
                                <th>Nights</th>
                                <th>Status</th>
                                <th>Room Price</th>
                                <th>Add-on</th>
                                <th>Total</th>
                                <th>Method</th>
                                <th>Date</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (Payment p : list) {
                                    String statusClass = "status-notpaid";
                                    if ("paid".equalsIgnoreCase(p.getStatus())) {
                                        statusClass = "status-paid";
                                    }
                                    double liveTotal = new HMS.Payment.PaymentDAO().calculateFinalTotal(p.getBillID());

                                    int nights = 1;
                                    if (p.getCheckInDate() != null && p.getCheckOutDate() != null) {
                                        nights = (int) java.time.temporal.ChronoUnit.DAYS.between(
                                                p.getCheckInDate().toLocalDateTime().toLocalDate(),
                                                p.getCheckOutDate().toLocalDateTime().toLocalDate()
                                        );
                                        if (nights <= 0) {
                                            nights = 1;
                                        }
                                    }
                            %>
                            <tr>
                                <td><a class="bill-link" href="viewBill.jsp?billID=<%= p.getBillID()%>"><%= p.getBillID()%></a></td>
                                <td><%= p.getReservationID()%></td>
                                <td><%= p.getGuestName() != null ? p.getGuestName() : "-"%></td>
                                <td><%= p.getRoomType() != null ? p.getRoomType() : "-"%></td>
                                <td><%= nights%></td>
                                <td class="<%= statusClass%>"><%= p.getStatus()%></td>
                                <td>RM <%= String.format("%.2f", p.getRoomTotal())%></td>
                                <td>RM <%= String.format("%.2f", p.getAddOnTotal())%></td>
                                <td><strong>RM <%= String.format("%.2f", liveTotal)%></strong></td>
                                <td><%= p.getPaymentMethod() != null ? p.getPaymentMethod() : "-"%></td>
                                <td><%= p.getPaymentDate() != null ? p.getPaymentDate() : "-"%></td>
                                <td>
                                    <a href="updatePayment.jsp?billID=<%= p.getBillID()%>" class="btn btn-sm btn-outline-primary">
                                        <i class="bi bi-pencil-square"></i> Update
                                    </a>
                                    <a href="viewBill.jsp?billID=<%= p.getBillID()%>" class="btn btn-info btn-sm">
                                        <i class="bi bi-eye"></i>
                                        View Details
                                    </a>    
                                </td>
                            </tr>
                            <%
                                }

                            %>
                        </tbody>
                    </table>

                </div>
                <% }%>
                <a href="billDashboard.jsp" class="btn-back mt-3 d-inline-block"><i class="bi bi-arrow-left"></i> Back</a>

                <i class="bi bi-eye"></i> View
                </a>

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
