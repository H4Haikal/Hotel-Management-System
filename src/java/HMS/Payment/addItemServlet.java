package HMS.Payment;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class addItemServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String reservationID = request.getParameter("reservationID");
        String description = request.getParameter("itemDescription");
        String amountParam = request.getParameter("itemAmount");

        response.setContentType("text/html;charset=UTF-8");

        try {
            // Validate input
            if (reservationID == null || reservationID.trim().isEmpty()) {
                throw new IllegalArgumentException("Missing reservationID.");
            }
            if (description == null || description.trim().isEmpty()) {
                throw new IllegalArgumentException("Item description cannot be empty.");
            }
            if (amountParam == null || amountParam.trim().isEmpty()) {
                throw new IllegalArgumentException("Item amount cannot be empty.");
            }

            double amount = Double.parseDouble(amountParam);
            if (amount < 0) {
                throw new IllegalArgumentException("Item amount must be positive.");
            }

            // DAO logic
            PaymentDAO dao = new PaymentDAO();
            int billID = dao.getBillIDByReservationID(reservationID);
            if (billID == -1) {
                throw new IllegalArgumentException("No bill found for reservation ID: " + reservationID);
            }

            // Create and insert item
            PaymentItem item = new PaymentItem();
            item.setBillID(billID);
            item.setItemDescription(description.trim());
            item.setItemAmount(amount);
            dao.insertPaymentItem(item);

            // ✅ FIX: Recalculate correct total including room and add-ons
            dao.updateTotalAmount(billID);

            // Redirect or show success
            response.sendRedirect("addItem.jsp?success=true");

        } catch (NumberFormatException e) {
            response.getWriter().println("Invalid amount: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            response.getWriter().println("Input error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Server error: " + e.getMessage());
        }
    }
}
