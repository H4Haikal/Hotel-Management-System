package HMS.Payment;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class updatePayServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int billID = Integer.parseInt(request.getParameter("billID"));
            String reference = request.getParameter("paymentReference"); // or "paymentReference"
            String method = request.getParameter("paymentMethod");
            String date = request.getParameter("paymentDate");

            PaymentDAO dao = new PaymentDAO();
            dao.updatePaymentStatus(billID, method, date, reference);

            // Optionally update total amount here if needed
            dao.updateTotalAmount(billID);

            response.sendRedirect("listPayment.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error updating payment: " + e.getMessage());
        }
    }
}
