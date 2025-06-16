<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="HMS.Payment.PaymentDAO, HMS.Payment.Payment" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    List<Payment> bills = null;
    try {
        PaymentDAO dao = new PaymentDAO();
        bills = dao.getUnpaidPayments(); // fetch only unpaid bills
    } catch (Exception e) {
        errorMessage = "Error loading bills: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Add-On Services</title>

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

            .card {
                padding: 25px;
            }

            .form-label {
                font-weight: bold;
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
                <h1 class="mb-4"><i class="bi bi-plus-circle"></i> Add Add-on Services</h1>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger"><%= errorMessage%></div>
                </c:if>

                <c:if test="${empty errorMessage}">
                    <div class="card shadow-sm">
                        <form action="addItemServlet" method="post">
                            <div class="mb-3">
                                <label for="reservationID" class="form-label">Select Reservation ID:</label>
                                <select name="reservationID" id="reservationID" class="form-select" required>
                                    <option value="" disabled selected>-- Select Reservation --</option>
                                    <%
                                        if (bills != null) {
                                            for (Payment bill : bills) {
                                    %>
                                    <option value="<%= bill.getReservationID()%>">
                                        Reservation ID: <%= bill.getReservationID()%>
                                    </option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="itemDescription" class="form-label">Item Description:</label>
                                <input type="text" class="form-control" id="itemDescription" name="itemDescription" required>
                            </div>

                            <div class="mb-3">
                                <label for="itemAmount" class="form-label">Amount:</label>
                                <input type="number" class="form-control" id="itemAmount" name="itemAmount" step="0.01" min="0" required>
                            </div>

                            <button type="submit" class="btn btn-primary">Add Item</button>
                        </form>
                    </div>
                </c:if>

                <button type="button" onclick="history.back()" class="btn-back mt-3">
                    <i class="bi bi-arrow-left"></i> Back
                </button>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
