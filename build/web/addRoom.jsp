<%-- 
    Document   : addRoom.jsp
    Created on : 25 May 2025, 8:40:20 pm
    Author     : User
--%>

<%@page import="java.sql.*, hotel.management.DBConnection" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String roomNo = request.getParameter("roomNo");
        String roomType = request.getParameter("roomType");
        String roomPrice = request.getParameter("roomPrice");
        String roomStatus = request.getParameter("roomStatus");

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement("INSERT INTO room (roomNo, roomType, roomPrice, roomStatus) VALUES (?, ?, ?, ?)");
            stmt.setInt(1, Integer.parseInt(roomNo));
            stmt.setString(2, roomType);
            stmt.setBigDecimal(3, new java.math.BigDecimal(roomPrice));
            stmt.setString(4, roomStatus);
            stmt.executeUpdate();

            response.sendRedirect("roomDashboard.jsp");
            return;
        } catch (Exception e) {
            request.setAttribute("errorMsg", "Error adding room: " + e.getMessage());
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Add New Room</title>
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
        </style>
    </head>
    <body>
        <%@ include file="include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container">
                <h1 class="mb-4"><i class="bi bi-plus-circle"></i> Add New Room</h1>

                <% if (request.getAttribute("errorMsg") != null) {%>
                <div class="alert alert-danger"><%= request.getAttribute("errorMsg")%></div>
                <% }%>

                <form method="post" class="card p-4 shadow-sm bg-white rounded">
                    <div class="mb-3">
                        <label class="form-label">Room Number</label>
                        <input type="number" name="roomNo" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Room Type</label>
                        <select name="roomType" class="form-select" required>
                            <option value="">-- Select Type --</option>
                            <option value="Single">Single</option>
                            <option value="Deluxe">Deluxe</option>
                            <option value="Suite">Suite</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Room Price (RM)</label>
                        <input type="text" name="roomPrice" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Room Status</label>
                        <select name="roomStatus" class="form-select" required>
                            <option value="">-- Select Status --</option>
                            <option value="Available">Available</option>
                            <option value="Occupied">Occupied</option>
                            <option value="Maintenance">Maintenance</option>
                        </select>
                    </div>
                    <div class="d-flex justify-content-between">
                        <button type="submit" class="btn btn-success"><i class="bi bi-save"></i> Save Room</button>
                        <a href="roomDashboard.jsp" class="btn btn-secondary"><i class="bi bi-arrow-left"></i> Back</a>
                    </div>
                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
