<%@page import="java.sql.*, java.util.*, java.time.*, java.time.format.*, hotel.management.DBConnection"%>
<%@page session="true" contentType="text/html" pageEncoding="UTF-8"%>
<%
    String guestName = request.getParameter("guestName");
    String guestAddr = request.getParameter("guestAddr");
    String guestPhone = request.getParameter("guestPhone");
    String guestEmail = request.getParameter("guestEmail");

    String roomType = request.getParameter("roomType");
    String checkInDateStr = request.getParameter("checkInDate");
    String checkOutDateStr = request.getParameter("checkOutDate");
    String selectedRoomNoStr = request.getParameter("selectedRoomNo");

    Connection conn = null;
    String message = "";

    try {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        LocalDateTime checkIn = LocalDateTime.parse(checkInDateStr, formatter);
        LocalDateTime checkOut = LocalDateTime.parse(checkOutDateStr, formatter);
        LocalDateTime now = LocalDateTime.now();

        if (checkIn.isBefore(now) || checkOut.isBefore(now) || !checkOut.isAfter(checkIn)) {
            message = "Invalid date selection. Dates must be in the future and check-out must be after check-in.";
            request.setAttribute("message", message);
            request.getRequestDispatcher("reservationPage.jsp").forward(request, response);
            return;
        }

        if (selectedRoomNoStr == null || selectedRoomNoStr.trim().isEmpty()) {
            message = "Error: No room selected. Please select a room.";
            request.setAttribute("message", message);
            request.getRequestDispatcher("reservationPage.jsp").forward(request, response);
            return;
        }

        int selectedRoomNo = Integer.parseInt(selectedRoomNoStr);

        conn = DBConnection.getConnection();
        conn.setAutoCommit(false);

        // Check if room is available for that date
        PreparedStatement overlapCheck = conn.prepareStatement(
                "SELECT * FROM reservation WHERE roomNo = ? AND "
                + "( (checkInDate <= ? AND checkOutDate > ?) OR (checkInDate < ? AND checkOutDate >= ?) OR (checkInDate >= ? AND checkOutDate <= ?) )"
        );
        overlapCheck.setInt(1, selectedRoomNo);
        overlapCheck.setString(2, checkInDateStr);
        overlapCheck.setString(3, checkInDateStr);
        overlapCheck.setString(4, checkOutDateStr);
        overlapCheck.setString(5, checkOutDateStr);
        overlapCheck.setString(6, checkInDateStr);
        overlapCheck.setString(7, checkOutDateStr);

        ResultSet conflict = overlapCheck.executeQuery();
        if (conflict.next()) {
            message = "Room is already booked during selected dates. Please choose another room or date.";
            request.setAttribute("message", message);
            request.getRequestDispatcher("reservationPage.jsp").forward(request, response);
            return;
        }

        // Generate guest ID
        Statement st = conn.createStatement();
        ResultSet rsGuest = st.executeQuery("SELECT MAX(guestID) FROM guest");

        String guestID = "G001";
        if (rsGuest.next() && rsGuest.getString(1) != null) {
            String lastID = rsGuest.getString(1);
            int num = Integer.parseInt(lastID.substring(1));
            guestID = "G" + String.format("%03d", num + 1);
        }

        PreparedStatement guestStmt = conn.prepareStatement(
                "INSERT INTO guest (guestID, guestName, guestAddr, guestPhone, guestEmail) VALUES (?, ?, ?, ?, ?)"
        );
        guestStmt.setString(1, guestID);
        guestStmt.setString(2, guestName);
        guestStmt.setString(3, guestAddr);
        guestStmt.setString(4, guestPhone);
        guestStmt.setString(5, guestEmail);
        guestStmt.executeUpdate();

        // Reservation ID
        ResultSet rsRes = st.executeQuery("SELECT MAX(reservationID) FROM reservation");
        String reservationID = "R001";
        if (rsRes.next() && rsRes.getString(1) != null) {
            int num = Integer.parseInt(rsRes.getString(1).substring(1));
            reservationID = "R" + String.format("%03d", num + 1);
        }

        PreparedStatement resStmt = conn.prepareStatement(
                "INSERT INTO reservation (reservationID, guestID, checkInDate, checkOutDate, roomType, roomNo, status) VALUES (?, ?, ?, ?, ?, ?, 'pending')"
        );
        resStmt.setString(1, reservationID);
        resStmt.setString(2, guestID);
        resStmt.setString(3, checkInDateStr);
        resStmt.setString(4, checkOutDateStr);
        resStmt.setString(5, roomType);
        resStmt.setInt(6, selectedRoomNo);
        resStmt.executeUpdate();

        PreparedStatement updateRoomStmt = conn.prepareStatement(
                "UPDATE room SET roomStatus = 'pending' WHERE roomNo = ?"
        );
        updateRoomStmt.setInt(1, selectedRoomNo);
        updateRoomStmt.executeUpdate();

        message = "Reservation added successfully!";
        conn.commit();

    } catch (Exception e) {
        message = "Error: " + e.getMessage();
        if (conn != null) try {
            conn.rollback();
        } catch (Exception ex) {
        }
    } finally {
        if (conn != null) try {
            conn.close();
        } catch (Exception ex) {
        }
        request.setAttribute("message", message);
        request.getRequestDispatcher("reservationPage.jsp").forward(request, response);
    }
%>
