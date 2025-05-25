package hotel.management;

import java.io.IOException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;

public class UpdateTaskServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("staffID") == null) {
                response.sendRedirect("login.jsp");  // Or wherever login page is
                return;
            }

            int staffID = (int) session.getAttribute("staffID"); // Must be set during login

            HKDAO dao = new HKDAO();
            // Modify this method to return List<Map<String,String>> with assignmentID, taskName, roomNo, status, etc.
            List<Map<String, String>> assignedTasks = dao.getAssignedTasksForStaff(staffID);

            request.setAttribute("assignedTasks", assignedTasks);

            RequestDispatcher dispatcher = request.getRequestDispatcher("updateTask.jsp");
            dispatcher.forward(request, response);
        } catch (Exception ex) {
            Logger.getLogger(UpdateTaskServlet.class.getName()).log(Level.SEVERE, null, ex);
            response.sendError(500, "Internal server error");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String assignmentID = request.getParameter("assignmentID");  // Changed from taskID
            String taskStatus = request.getParameter("taskStatus");

            if (assignmentID == null || taskStatus == null) {
                response.sendRedirect("UpdateTaskServlet?message=Invalid input");
                return;
            }

            HKDAO dao = new HKDAO();
            boolean success = dao.updateTaskStatusByAssignmentID(assignmentID, taskStatus);

            if (success) {
                response.sendRedirect("UpdateTaskServlet?message=Task updated successfully.");
            } else {
                response.sendRedirect("UpdateTaskServlet?message=Failed to update task.");
            }
        } catch (Exception ex) {
            Logger.getLogger(UpdateTaskServlet.class.getName()).log(Level.SEVERE, null, ex);
            response.sendRedirect("UpdateTaskServlet?message=Error occurred during update.");
        }
    }
}
