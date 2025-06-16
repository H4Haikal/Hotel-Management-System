package HMS.Payment;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;

public class RemovePaymentItemServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int billID = Integer.parseInt(request.getParameter("billID"));
            int itemID = Integer.parseInt(request.getParameter("itemID"));
            
            PaymentDAO dao = new PaymentDAO();
            dao.removePaymentItem(itemID); // implement this method to DELETE from DB
            dao.updateTotalAmount(billID); // recalculate after deletion

            response.sendRedirect("viewBill.jsp?billID=" + billID);
        } catch (Exception ex) {
            Logger.getLogger(RemovePaymentItemServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
