package hotel.management;

import java.sql.*;
import java.util.*;

/**
 *
 * @author tikahosh
 */
public class HKDAO {

    // get connction from php
    private Connection getConnection() throws Exception {
        return hotel.management.DBConnection.getConnection();
    }

    // to insert into the assignment table
    public int insertAssignment(int staffID, int roomNo) throws SQLException, ClassNotFoundException, Exception {
        String query = "INSERT INTO HousekeepingAssignment (housekeepingStaffID, roomAssigned) VALUES (?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, staffID);
            ps.setInt(2, roomNo);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new SQLException("Failed to retrieve generated assignment ID.");
                }
            }
        }
    }

    // to get assigned task from AssignedTask.jsp
    public void insertAssignedTasks(int assignmentID, List<String> taskIDs) throws SQLException, ClassNotFoundException, Exception {
        String query = "INSERT INTO AssignedTask (assignmentID, taskID, taskStatus) VALUES (?, ?, 'NOT DONE')";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            for (String taskID : taskIDs) {
                ps.setInt(1, assignmentID);
                ps.setString(2, taskID);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    // to update the task status in UpdateTask.jsp
    public boolean updateTaskStatus(String taskID, String taskStatus) throws Exception {
        String sql = "UPDATE AssignedTask SET taskStatus = ? WHERE taskID = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, taskStatus);
            stmt.setString(2, taskID);
            return stmt.executeUpdate() > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Gets task IDs assigned to a specific housekeeping staff member
    public List<String> getAssignedTaskIDs(int staffID) throws Exception {
        List<String> taskIDs = new ArrayList<>();
        String sql = "SELECT at.taskID FROM AssignedTask at "
                + "JOIN HousekeepingAssignment ha ON at.assignmentID = ha.assignmentID "
                + "WHERE ha.housekeepingStaffID = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, staffID);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                taskIDs.add(rs.getString("taskID"));
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return taskIDs;
    }

    public List<Map<String, String>> getAssignedTasksForStaff(int staffID) throws Exception {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT a.assignmentID, t.taskName, r.roomNo, a.status "
                + "FROM AssignedTask a "
                + "JOIN HousekeepingTask t ON a.taskID = t.taskID "
                + "JOIN Room r ON a.roomNo = r.roomNo "
                + "WHERE a.staffID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, staffID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> map = new HashMap<>();
                    map.put("assignmentID", rs.getString("assignmentID"));
                    map.put("taskName", rs.getString("taskName"));
                    map.put("roomNo", rs.getString("roomNo"));
                    map.put("status", rs.getString("status"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public boolean updateTaskStatusByAssignmentID(String assignmentID, String status) throws Exception {
        String sql = "UPDATE AssignedTask SET status = ? WHERE assignmentID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, assignmentID);
            int updated = ps.executeUpdate();
            return updated > 0;
        }
    }

}
