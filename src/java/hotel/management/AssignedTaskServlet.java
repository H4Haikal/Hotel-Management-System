package hotel.management;

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.sql.*;
import java.util.*;

/**
 *
 * @author tikahosh
 */
@WebServlet("/AssignedTaskServlet")
public class AssignedTaskServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String staffIDParam = request.getParameter("staffID");
        String roomNoParam = request.getParameter("roomNo");
        String[] taskIDArray = request.getParameterValues("taskID");
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html><head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<title>Assign Task Result</title>");
        out.println("<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css' rel='stylesheet'>");
        out.println("<link href='https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css' rel='stylesheet'>");
        out.println("<link rel='stylesheet' href='Housekeeping.css'/>");
        out.println("<style>");
        out.println(".main-content { margin-left: 250px; padding: 30px; background-color: #f8f9fa; min-height: 100vh; }");
        out.println("</style>");
        out.println("</head><body>");

        // Simulate sidebar include
        request.getRequestDispatcher("include/sidebar.jsp").include(request, response);

        out.println("<div class='main-content'>");
        out.println("<div class='container mt-5'>");

        if (taskIDArray == null || taskIDArray.length == 0) {
            out.println("<div class='alert alert-warning'><h4>Please select at least one task.</h4></div>");
            out.println("<a href='AssignedTask.jsp' class='btn btn-primary mt-3'><i class='bi bi-arrow-left'></i> Back to Assign Page</a>");
            out.println("</div></div></body></html>");
            return;
        }

        try {
            int staffID = Integer.parseInt(staffIDParam);
            int roomNo = Integer.parseInt(roomNoParam);
            List<String> taskIDs = Arrays.asList(taskIDArray);
            

            HKDAO dao = new HKDAO();
            int assignmentID = dao.insertAssignment(staffID, roomNo);
            dao.insertAssignedTasks(assignmentID, taskIDs);

            out.println("<div class='alert alert-success'><h4><i class='bi bi-check-circle-fill'></i> Tasks assigned successfully!</h4></div>");
            out.println("<a href='AssignedTask.jsp' class='btn btn-success'><i class='bi bi-plus-circle'></i> Assign Another Task</a>");

        } catch (NumberFormatException e) {
            out.println("<div class='alert alert-danger'><h4><i class='bi bi-exclamation-circle'></i> Invalid room number format.</h4></div>");
            out.println("<a href='AssignedTask.jsp' class='btn btn-primary mt-3'><i class='bi bi-arrow-left'></i> Back to Assign Page</a>");

        } catch (Exception e) {
            e.printStackTrace(out);
            out.println("<div class='alert alert-danger'><h4><i class='bi bi-x-circle'></i> Unable to assign tasks. Please try again.</h4></div>");
            out.println("<a href='AssignedTask.jsp' class='btn btn-primary mt-3'><i class='bi bi-arrow-left'></i> Back to Assign Page</a>");
        }

        out.println("</div></div>"); // close main-content and container
        out.println("<script src='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js'></script>");
        out.println("</body></html>");
    }

}
