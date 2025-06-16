/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package HMS.Payment;

import hotel.management.DBConnection;
import java.sql.*;
import java.util.*;
import java.sql.*;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public int createEmptyBill(String reservationID) throws Exception {
        String sql = "INSERT INTO payment (reservationID, status) VALUES (?, 'not paid yet')";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, reservationID);
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1;
    }

    public int createPaymentForReservation(String reservationID) throws Exception {
        String sql = "INSERT INTO payment (reservationID, status) VALUES (?, 'Not Paid Yet')";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, reservationID);
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1;
    }

    public void insertPaymentItem(PaymentItem item) throws Exception {
        String sql = "INSERT INTO paymentItem (billID, itemDescription, itemAmount) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, item.getBillID());
            stmt.setString(2, item.getItemDescription());
            stmt.setDouble(3, item.getItemAmount());
            stmt.executeUpdate();
        }
        // Update total amount after inserting a new item
        updateTotalAmount(item.getBillID());
    }

    public void updateTotalAmount(int billID) throws Exception {
        String sql = "SELECT r.checkInDate, r.checkOutDate, rm.roomPrice "
                + "FROM payment p "
                + "JOIN reservation r ON p.reservationID = r.reservationID "
                + "JOIN room rm ON r.roomNo = rm.roomNo "
                + "WHERE p.billID = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, billID);
            ResultSet rs = stmt.executeQuery();

            double roomTotal = 0;
            if (rs.next()) {
                Timestamp checkInTs = rs.getTimestamp("checkInDate");
                Timestamp checkOutTs = rs.getTimestamp("checkOutDate");
                double roomPrice = rs.getDouble("roomPrice");

                // ✅ Convert to LocalDate to avoid time part problems
                LocalDate checkIn = checkInTs.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
                LocalDate checkOut = checkOutTs.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();

                long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
                if (nights <= 0) {
                    nights = 1; // fallback: 1 night minimum
                }
                roomTotal = nights * roomPrice;
            }

            // ✅ Get add-on total
            double addonTotal = 0;
            String addonSql = "SELECT COALESCE(SUM(itemAmount), 0) FROM paymentItem WHERE billID = ?";
            try (PreparedStatement addonStmt = conn.prepareStatement(addonSql)) {
                addonStmt.setInt(1, billID);
                ResultSet rs2 = addonStmt.executeQuery();
                if (rs2.next()) {
                    addonTotal = rs2.getDouble(1);
                }
            }

            double finalTotal = roomTotal + addonTotal;

            // ✅ Update the payment record
            String updateSql = "UPDATE payment SET totalAmount = ? WHERE billID = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setDouble(1, finalTotal);
                updateStmt.setInt(2, billID);
                updateStmt.executeUpdate();
            }
        }
    }

    public Payment getPaymentByBillID(int billID) throws Exception {
        String sql = "SELECT p.billID, p.reservationID, p.paymentDate, p.paymentMethod, p.status, "
                + "p.totalAmount, p.paymentReference, g.guestName, "
                + "r.roomType, r.roomNo, r.checkInDate, r.checkOutDate, rm.roomPrice "
                + "FROM payment p "
                + "JOIN reservation r ON r.reservationID = p.reservationID "
                + "JOIN guest g ON g.guestID = r.guestID "
                + "JOIN room rm ON r.roomNo = rm.roomNo "
                + "WHERE p.billID = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, billID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Payment p = new Payment();
                p.setBillID(rs.getInt("billID"));
                p.setReservationID(rs.getString("reservationID"));
                p.setPaymentDate(rs.getString("paymentDate"));
                p.setPaymentMethod(rs.getString("paymentMethod"));
                p.setPaymentReference(rs.getString("paymentReference"));
                p.setStatus(rs.getString("status"));
                p.setTotalAmount(rs.getDouble("totalAmount"));
                p.setGuestName(rs.getString("guestName"));
                p.setRoomNo(rs.getInt("roomNo"));
                // ✅ New fields
                p.setRoomType(rs.getString("roomType"));
                p.setCheckInDate(rs.getTimestamp("checkInDate"));
                p.setCheckOutDate(rs.getTimestamp("checkOutDate"));
                p.setRoomPrice(rs.getDouble("roomPrice"));

                // You can optionally calculate room total based on roomPrice and nights here
                double roomPrice = rs.getDouble("roomPrice");
                if (p.getCheckInDate() != null && p.getCheckOutDate() != null) {
                    long nights = ChronoUnit.DAYS.between(
                            p.getCheckInDate().toLocalDateTime().toLocalDate(),
                            p.getCheckOutDate().toLocalDateTime().toLocalDate()
                    );
                    if (nights <= 0) {
                        nights = 1;
                    }
                    p.setRoomTotal(roomPrice * nights); // set in bean
                }

                return p;
            }
        }
        return null;
    }

    public List<PaymentItem> getPaymentItems(int billID) throws Exception {
        List<PaymentItem> items = new ArrayList<>();
        String sql = "SELECT itemID, billID, itemDescription, itemAmount FROM paymentItem WHERE billID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, billID);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                PaymentItem item = new PaymentItem();
                item.setItemID(rs.getInt("itemID"));
                item.setBillID(rs.getInt("billID"));
                item.setItemDescription(rs.getString("itemDescription"));
                item.setItemAmount(rs.getDouble("itemAmount"));
                items.add(item);
            }
        }
        return items;
    }

    public void updatePaymentStatus(int billID, String method, String date, String paymentReference) throws Exception {
        String sql = "UPDATE payment SET paymentMethod = ?, paymentDate = ?, paymentReference = ?, status = 'Paid' WHERE billID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, method);
            stmt.setString(2, date);
            stmt.setString(3, paymentReference);
            stmt.setInt(4, billID);
            stmt.executeUpdate();
        }
    }

    public int getBillIDByReservationID(String reservationID) throws Exception {
        String sql = "SELECT billID FROM payment WHERE reservationID = ? AND LOWER(status) = 'not paid yet' LIMIT 1";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, reservationID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("billID");
            }
        }
        return -1; // Not found
    }

    public List<Integer> getUnpaidBillIDs() throws Exception {
        String sql = "SELECT billID FROM payment WHERE status = 'Not Paid Yet'";
        List<Integer> billIDs = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                billIDs.add(rs.getInt("billID"));
            }
        }
        return billIDs;
    }

    public List<Payment> getUnpaidPayments() throws Exception {
        String sql = "SELECT p.*, COALESCE(SUM(i.itemAmount), 0) AS totalAmount "
                + "FROM payment p LEFT JOIN paymentItem i ON p.billID = i.billID "
                + "WHERE LOWER(p.status) = 'not paid yet' "
                + "GROUP BY p.billID";
        List<Payment> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Payment p = new Payment();
                p.setBillID(rs.getInt("billID"));
                p.setReservationID(rs.getString("reservationID"));
                p.setPaymentDate(rs.getString("paymentDate"));
                p.setPaymentMethod(rs.getString("paymentMethod"));
                p.setStatus(rs.getString("status"));
                p.setTotalAmount(rs.getDouble("totalAmount"));
                list.add(p);
            }
        }
        return list;
    }

    // Calculate total amount for a given billID (sum of all paymentItem amounts)
    public double calculateTotal(int billID) throws Exception {
        String sql = "SELECT COALESCE(SUM(itemAmount), 0) FROM paymentItem WHERE billID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, billID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0.0;
    }

    public List<Payment> getAllPayments() throws Exception {
        String sql = "SELECT "
                + "p.*, "
                + "r.roomNo, r.roomType, r.checkInDate, r.checkOutDate, "
                + "rm.roomPrice, "
                + "g.guestName, "
                + "COALESCE(SUM(i.itemAmount), 0) AS addOnTotal "
                + "FROM payment p "
                + "JOIN reservation r ON r.reservationID = p.reservationID "
                + "JOIN guest g ON g.guestID = r.guestID "
                + "JOIN room rm ON r.roomNo = rm.roomNo "
                + "LEFT JOIN paymentItem i ON p.billID = i.billID "
                + "GROUP BY p.billID";

        List<Payment> list = new ArrayList<>();
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Payment p = new Payment();
                p.setBillID(rs.getInt("billID"));
                p.setReservationID(rs.getString("reservationID"));
                p.setPaymentDate(rs.getString("paymentDate"));
                p.setPaymentMethod(rs.getString("paymentMethod"));
                p.setStatus(rs.getString("status"));
                p.setPaymentReference(rs.getString("paymentReference"));
                p.setReservationStatus(rs.getString("status"));
                p.setGuestName(rs.getString("guestName"));

                // Room details
                p.setRoomType(rs.getString("roomType"));
                p.setRoomNo(rs.getInt("roomNo"));
                p.setCheckInDate(rs.getTimestamp("checkInDate"));
                p.setCheckOutDate(rs.getTimestamp("checkOutDate"));
                p.setRoomPrice(rs.getDouble("roomPrice"));

                // ✅ Calculate nights using ChronoUnit
                Timestamp checkInTs = rs.getTimestamp("checkInDate");
                Timestamp checkOutTs = rs.getTimestamp("checkOutDate");

                LocalDate checkIn = checkInTs.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
                LocalDate checkOut = checkOutTs.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
                long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
                if (nights <= 0) {
                    nights = 1;
                }

                p.setNights((int) nights);
                double roomTotal = nights * rs.getDouble("roomPrice");
                p.setRoomTotal(roomTotal);

                // Add-on total from SQL
                double addOn = rs.getDouble("addOnTotal");
                p.setAddOnTotal(addOn);

                // Total amount
                p.setTotalAmount(roomTotal + addOn);

                list.add(p);
            }
        }
        return list;
    }

    public double calculateFinalTotal(int billID) throws Exception {
        String sql = "SELECT r.checkInDate, r.checkOutDate, rm.roomPrice "
                + "FROM payment p "
                + "JOIN reservation r ON p.reservationID = r.reservationID "
                + "JOIN room rm ON r.roomNo = rm.roomNo "
                + "WHERE p.billID = ?";

        double roomTotal = 0;
        double addonTotal = 0;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, billID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Timestamp checkInTs = rs.getTimestamp("checkInDate");
                Timestamp checkOutTs = rs.getTimestamp("checkOutDate");
                double roomPrice = rs.getDouble("roomPrice");

                LocalDate checkIn = checkInTs.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
                LocalDate checkOut = checkOutTs.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();

                long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
                if (nights <= 0) {
                    nights = 1;
                }

                roomTotal = nights * roomPrice;
            }

            // Get add-on total
            String addonSql = "SELECT COALESCE(SUM(itemAmount), 0) FROM paymentItem WHERE billID = ?";
            try (PreparedStatement addonStmt = conn.prepareStatement(addonSql)) {
                addonStmt.setInt(1, billID);
                ResultSet rs2 = addonStmt.executeQuery();
                if (rs2.next()) {
                    addonTotal = rs2.getDouble(1);
                }
            }
        }

        return roomTotal + addonTotal;
    }

    public void removePaymentItem(int itemID) {
        String sql = "DELETE FROM paymentitem WHERE itemID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, itemID);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
