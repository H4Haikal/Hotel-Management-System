package hotel.management;

import java.sql.*;
import java.util.*;

public class HKDAO {

    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }

    // Insert new assignment (staff + room)
    public int insertAssignment(int staffID, int roomNo) throws Exception {
        String sql = "INSERT INTO HousekeepingAssignment (housekeepingStaffID, roomAssigned) VALUES (?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, staffID);
            ps.setInt(2, roomNo);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            } else {
                throw new SQLException("Assignment ID not generated.");
            }
        }
    }

    // Insert multiple assigned tasks for the assignment
    public void insertAssignedTasks(int assignmentID, List<String> taskIDs) throws Exception {
        String sql = "INSERT INTO AssignedTask (assignmentID, taskID, taskStatus) VALUES (?, ?, 'NOT DONE')";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            for (String taskID : taskIDs) {
                ps.setInt(1, assignmentID);
                ps.setString(2, taskID);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    public boolean updateTaskStatus(int assignmentID, String status) throws Exception {
        String sql = "UPDATE housekeepingassignment SET housekeepingStatus = ? WHERE assignmentID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, assignmentID);
            return ps.executeUpdate() > 0;
        }
    }

    // Update all tasks under one assignment
    public boolean updateTasksByAssignment(int assignmentID, String status) throws Exception {
        String sql = "UPDATE AssignedTask SET taskStatus = ? WHERE assignmentID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, assignmentID);
            return ps.executeUpdate() > 0;
        }
    }

    // Get all assignments and task info for an admin to view
    public List<AssignTask> getAllAssignedTasks() throws Exception {
        List<AssignTask> list = new ArrayList<>();

        String sql = "SELECT at.assignmentID, at.taskID, ht.taskName, ha.roomAssigned AS roomNo, at.taskStatus "
                + "FROM AssignedTask at "
                + "JOIN HousekeepingAssignment ha ON at.assignmentID = ha.assignmentID "
                + "JOIN HousekeepingTask ht ON at.taskID = ht.taskID";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AssignTask task = new AssignTask();
                    task.setAssignmentID(rs.getInt("assignmentID"));
                    task.setTaskID(rs.getString("taskID"));
                    task.setTaskName(rs.getString("taskName"));
                    task.setRoomNo(rs.getInt("roomNo"));
                    task.setStatus(rs.getString("taskStatus"));
                    list.add(task);
                }
            }
        }

        return list;
    }

    public boolean updateAssignmentStatus(int assignmentID, String status) throws Exception {
        String sql = "UPDATE assignedtask SET taskStatus = ? WHERE assignmentID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, assignmentID);
            return ps.executeUpdate() > 0;
        }
    }

}
