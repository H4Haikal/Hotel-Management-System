/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package hotel.management;

import HMS.Payment.Payment;
import java.sql.*;
import java.util.*;

public class ReportDAO {

    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }

    public List<AssignTask> getAllHousekeepingReports() throws Exception {
        List<AssignTask> list = new ArrayList<>();
        String sql = "SELECT at.assignmentID, s.staffName, ha.roomAssigned, ht.taskName, at.taskStatus "
                + "FROM assignedtask at "
                + "JOIN housekeepingassignment ha ON at.assignmentID = ha.assignmentID "
                + "JOIN housekeepingtask ht ON at.taskID = ht.taskID "
                + "JOIN staff s ON ha.housekeepingStaffID = s.staffID";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AssignTask task = new AssignTask();
                task.setAssignmentID(rs.getInt("assignmentID"));
                task.setTaskName(rs.getString("taskName"));
                task.setStatus(rs.getString("taskStatus"));
                task.setRoomNo(rs.getInt("roomAssigned"));
                task.setStaffName(rs.getString("staffName")); // Add in AssignTask model
                list.add(task);
            }
        }
        return list;
    }

    public List<Payment> getAllPaymentReports() throws Exception {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT * FROM payment ORDER BY paymentDate DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Payment pay = new Payment();
                pay.setBillID(rs.getInt("billID"));
                pay.setReservationID(rs.getString("reservationID"));
                pay.setTotalAmount(rs.getDouble("totalAmount"));
                pay.setPaymentDate(rs.getString("paymentDate"));
                pay.setPaymentMethod(rs.getString("paymentMethod"));
                pay.setStatus(rs.getString("status"));
                list.add(pay);
            }
        }
        return list;
    }

    public List<Guest> getAllGuests() throws Exception {
        List<Guest> guests = new ArrayList<>();
        String sql = "SELECT * FROM guest";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Guest g = new Guest();
                g.setGuestID(rs.getString("guestID"));
                g.setGuestName(rs.getString("guestName"));
                g.setEmail(rs.getString("guestEmail"));
                g.setPhone(rs.getString("guestPhone"));
                guests.add(g);
            }
        }
        return guests;
    }

    public List<Room> getAllRooms() throws Exception {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM room";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Room r = new Room();
                r.setRoomNo(rs.getInt("roomNo"));
                r.setRoomType(rs.getString("roomType"));
                r.setRoomPrice(rs.getDouble("roomPrice"));
                r.setRoomStatus(rs.getString("roomStatus"));
                rooms.add(r);
            }
        }
        return rooms;
    }

}
