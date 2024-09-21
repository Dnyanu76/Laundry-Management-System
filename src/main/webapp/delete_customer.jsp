<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Delete Customer</title>
    <link rel="stylesheet" type="text/css" href="<%= application.getContextPath() %>/css/delete.css">
</head>
<style>
body {
    background-color: #f2f2f2;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    font-family: Arial, sans-serif;
}

.container {
    width: 100%;
    max-width: 600px;
    margin: 100px auto;
    padding: 20px;
    background-color: white;
    border-radius: 10px;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
    text-align: center;
}

p {
    font-size: 18px;
    color: #333;
}

a {
    display: inline-block;
    margin-top: 20px;
    padding: 10px 20px;
    background-color: #1abc9c;
    color: white;
    text-decoration: none;
    border-radius: 5px;
    transition: background-color 0.3s;
}

a:hover {
    background-color: #16a085;
}
</style>
<body>
    <div class="container">
        
        <%
            String customerId = request.getParameter("customer_id");
            Connection conn = null;
            PreparedStatement pstmt = null;

            if (customerId != null && !customerId.isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String url = "jdbc:mysql://localhost:3306/laundry_management";
                    String user = "root";
                    String password = "";

                    // Establish the connection
                    conn = DriverManager.getConnection(url, user, password);

                    // Delete associated orders first
                    String deleteOrdersSql = "DELETE FROM laundry_order WHERE customer_id = ?";
                    pstmt = conn.prepareStatement(deleteOrdersSql);
                    pstmt.setInt(1, Integer.parseInt(customerId));
                    pstmt.executeUpdate();

                    // Now delete the customer
                    String deleteCustomerSql = "DELETE FROM customer WHERE customer_id = ?";
                    pstmt = conn.prepareStatement(deleteCustomerSql);
                    pstmt.setInt(1, Integer.parseInt(customerId));
                    
                    int rows = pstmt.executeUpdate();
                    if (rows > 0) {
                        out.println("<p>Customer and their orders deleted successfully!</p>");
                    } else {
                        out.println("<p>Error: Customer not found or failed to delete.</p>");
                    }
                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                } finally {
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { }
                }
            } else {
                out.println("<p>Error: No customer ID provided for deletion.</p>");
            }
        %>
        <a href="customer_list.jsp">Back to Customer List</a>
    </div>
</body>
</html>
