<%@ page import="java.sql.*, hotel.management.DBConnection" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    try {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM admin WHERE username = ? AND password = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, username);
        stmt.setString(2, password);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            // Successful login
            session.setAttribute("admin", username);
            session.setAttribute("staffID", rs.getInt("admin_id"));
            session.setAttribute("staffName", rs.getString("fullname"));  // Ensure this column exists
            response.sendRedirect("main.jsp");
        } else {
            // Failed login
            response.sendRedirect("login.jsp?error=1");
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("login.jsp?error=1");
    }
%>
