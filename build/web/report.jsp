<%@page import="HMS.Payment.Payment"%>
<%@page import="hotel.management.*, java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    ReportDAO dao = new ReportDAO();
    List<AssignTask> tasks = dao.getAllHousekeepingReports();
    List<Payment> payments = dao.getAllPaymentReports();
    List<Guest> guests = dao.getAllGuests();
    List<Room> rooms = dao.getAllRooms();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Reports</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.5/xlsx.full.min.js"></script>
        <style>
            .main-content {
                margin-left: 250px;
                padding: 30px;
                background-color: #f8f9fa;
                min-height: 100vh;
            }
            h2 {
/*                margin-top: 40px;*/
            }
            .table thead th {
                text-align: center;
            }
        </style>
    </head>
    <body>

        <%@ include file="include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container">
                <h1 class="mb-4"><i class="bi bi-bar-chart-fill"></i> Reports Dashboard</h1>

                <!-- Housekeeping Report -->
                <h2>Housekeeping Report</h2>
                <button onclick="downloadTable('housekeepingTable', 'Housekeeping_Report')" class="btn btn-outline-primary mb-3">
                    <i class="bi bi-download"></i> Download Excel
                </button>
                <table class="table table-bordered table-striped" id="housekeepingTable">
                    <thead class="table-dark">
                        <tr>
                            <th>Assignment ID</th>
                            <th>Room No</th>
                            <th>Task</th>
                            <th>Status</th>
                            <th>Staff Name</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (AssignTask task : tasks) {%>
                        <tr>
                            <td><%= task.getAssignmentID()%></td>
                            <td><%= task.getRoomNo()%></td>
                            <td><%= task.getTaskName()%></td>
                            <td><%= task.getStatus()%></td>
                            <td><%= task.getStaffName()%></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <!-- Payment Report -->
                <h2>Payment Report</h2>
                <button onclick="downloadTable('paymentTable', 'Payment_Report')" class="btn btn-outline-success mb-3">
                    <i class="bi bi-download"></i> Download Excel
                </button>
                <table class="table table-bordered table-striped" id="paymentTable">
                    <thead class="table-dark">
                        <tr>
                            <th>Bill ID</th>
                            <th>Reservation ID</th>
                            <th>Total (RM)</th>
                            <th>Date</th>
                            <th>Method</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Payment p : payments) {%>
                        <tr>
                            <td><%= p.getBillID()%></td>
                            <td><%= p.getReservationID()%></td>
                            <td>RM <%= String.format("%.2f", p.getTotalAmount())%></td>
                            <td><%= p.getPaymentDate() != null ? p.getPaymentDate() : "-"%></td>
                            <td><%= p.getPaymentMethod() != null ? p.getPaymentMethod() : "-"%></td>
                            <td><%= p.getStatus()%></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <!-- Guest Report -->
                <h2>Guest Report</h2>
                <button onclick="downloadTable('guestTable', 'Guest_Report')" class="btn btn-outline-warning mb-3">
                    <i class="bi bi-download"></i> Download Excel
                </button>
                <table class="table table-bordered table-striped" id="guestTable">
                    <thead class="table-dark">
                        <tr>
                            <th>Guest ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Guest g : guests) {%>
                        <tr>
                            <td><%= g.getGuestID()%></td>
                            <td><%= g.getGuestName()%></td>
                            <td><%= g.getEmail()%></td>
                            <td><%= g.getPhone()%></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <!-- Room Report -->
                <h2>Room Report</h2>
                <button onclick="downloadTable('roomTable', 'Room_Report')" class="btn btn-outline-danger mb-3">
                    <i class="bi bi-download"></i> Download Excel
                </button>
                <table class="table table-bordered table-striped" id="roomTable">
                    <thead class="table-dark">
                        <tr>
                            <th>Room No</th>
                            <th>Type</th>
                            <th>Price (RM)</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Room r : rooms) {%>
                        <tr>
                            <td><%= r.getRoomNo()%></td>
                            <td><%= r.getRoomType()%></td>
                            <td>RM <%= String.format("%.2f", r.getRoomPrice())%></td>
                            <td><%= r.getRoomStatus()%></td>
                        </tr>
                        <% }%>
                    </tbody>
                </table>
            </div>
        </div>

        <script>
            function downloadTable(tableId, filename) {
                const table = document.getElementById(tableId);
                const wb = XLSX.utils.table_to_book(table, {sheet: "Report"});
                XLSX.writeFile(wb, filename + ".xlsx");
            }
        </script>
    </body>
</html>
