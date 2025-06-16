package hotel.management;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class SubmitTaskStatusServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int assignmentID = Integer.parseInt(request.getParameter("assignmentID"));
            String newStatus = request.getParameter("taskStatus");

            HKDAO dao = new HKDAO();
            boolean success = dao.updateAssignmentStatus(assignmentID, newStatus);

            if (success) {
                response.sendRedirect("UpdateTask.jsp?message=Task+status+updated+successfully");
            } else {
                response.sendRedirect("UpdateTask.jsp?message=Failed+to+update+task+status");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("UpdateTask.jsp?message=Error+updating+task+status");
        }
    }
}
