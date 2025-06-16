package hotel.management;

import java.io.IOException;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;


public class AssignTaskServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String staffIDParam = request.getParameter("staffID");
        String roomNoParam = request.getParameter("roomNo");
        String[] taskIDArray = request.getParameterValues("taskID");

        if (staffIDParam == null || roomNoParam == null || taskIDArray == null) {
            request.setAttribute("message", "Missing input fields. Please try again.");
            request.getRequestDispatcher("AssignedTask.jsp").forward(request, response);
            return;
        }

        try {
            int staffID = Integer.parseInt(staffIDParam);
            int roomNo = Integer.parseInt(roomNoParam);
            List<String> taskIDs = Arrays.asList(taskIDArray);

            HKDAO dao = new HKDAO();
            int assignmentID = dao.insertAssignment(staffID, roomNo);
            dao.insertAssignedTasks(assignmentID, taskIDs);

            request.setAttribute("message", "Task(s) successfully assigned to staff!");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error occurred: " + e.getMessage());
        }

        request.getRequestDispatcher("AssignedTask.jsp").forward(request, response);
    }
}
