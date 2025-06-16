package HMS.Payment;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;

public class listPayServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            PaymentDAO dao = new PaymentDAO();
            List<Payment> list = dao.getAllPayments();
            request.setAttribute("payments", list);
            request.getRequestDispatcher("listPayments.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error fetching payments: " + e.getMessage());
        }
    }
}
