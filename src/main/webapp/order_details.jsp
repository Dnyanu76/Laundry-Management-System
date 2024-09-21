<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.jsp.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Details</title>
    <link rel="stylesheet" type="text/css" href="css/orders_detail.css">
</head>
<body>
    <div class="container">

        <%
            String id = request.getParameter("id");
        
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            String orderId = "";
            String customerId = "";
            String status = "";
            String inDate = "";
            String outDate = "";
            float weight = 0.0f;

            if (id != null && !id.isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String url = "jdbc:mysql://localhost:3306/laundry_management";
                    String user = "root";
                    String password = "";
                    conn = DriverManager.getConnection(url, user, password);
                    
                    String sql = "SELECT * FROM laundry_order WHERE order_id = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, Integer.parseInt(id));
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        orderId = rs.getString("order_id");
                        customerId = rs.getString("customer_id");
                        status = rs.getString("status");
                        inDate = rs.getDate("in_date").toString();
                        outDate = rs.getDate("out_date").toString();
                        weight = rs.getFloat("weight");
                        out.println(weight);
                    } else {
                        out.println("<p>Order not found.</p>");
                    }
					
                } catch (Exception e) {
                    //out.println("Error: " + e.getMessage());
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { }
                }
            } else {
                out.println("<p>Invalid Order ID.</p>");
            }
        %>

        <form>
            <label for="order_id">Order ID:</label>
            <input type="text" id="order_id" name="order_id" value="<%= orderId %>" readonly><br><br>

            <label for="customer_id">Customer ID:</label>
            <input type="text" id="customer_id" name="customer_id" value="<%= customerId %>" readonly><br><br>

            <label for="status">Status:</label>
            <input type="text" id="status" name="status" value="<%= status %>" readonly><br><br>

            <label for="in_date">In Date:</label>
            <input type="text" id="in_date" name="in_date" value="<%= inDate %>" readonly><br><br>

            <label for="out_date">Out Date:</label>
            <input type="text" id="out_date" name="out_date" value="<%= outDate %>" readonly><br><br>

          
        </form>

        <a href="order_list.jsp">Back to Order List</a>
    </div>
</body>
</html>
