<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.jsp.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Take Cloth</title>
    <link rel="stylesheet" type="text/css" href="css/take_cloth.css">
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h2>Staff Dashboard</h2>
        <ul>
            <li><a href="take_cloth.jsp">Take Cloth</a></li>
            <li><a href="add_customer.jsp">Create Customer</a></li>
            <li><a href="customer_list.jsp">See Customer List</a></li>
            <li><a href="order_list.jsp">See Orders</a></li>
            <li><a href="index.jsp">log out</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container">
            <h1>Take Cloth</h1>

            <form method="post" action="take_cloth.jsp">
                <label for="customer_id">Customer ID:</label>
                <input type="text" id="customer_id" name="customer_id" required>

                <label for="cloth_weight">Weight of Cloth (kg):</label>
                <input type="number" id="cloth_weight" name="cloth_weight" step="0.1" min="0" required>
					
				<input type="text" id="status" name="status" value="Not Washed" required hidden>


                <input type="submit" value="Submit">
            </form>

            <%
                String customerId = request.getParameter("customer_id");
            
                String clothWeight = request.getParameter("cloth_weight");
                //out.println(clothWeight);
                String status = request.getParameter("status");

                if (customerId != null && clothWeight != null && status != null) {
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        String url = "jdbc:mysql://localhost:3306/laundry_management";
                        String user = "root";
                        String password = "";
                        conn = DriverManager.getConnection(url, user, password);

                        // Check if the customer ID exists
                        String checkCustomerSql = "SELECT COUNT(*) FROM customer WHERE customer_id = ?";
                        pstmt = conn.prepareStatement(checkCustomerSql);
                        pstmt.setInt(1, Integer.parseInt(customerId));
                        rs = pstmt.executeQuery();
                        rs.next();
                        int count = rs.getInt(1);

                        if (count == 0) {
                            out.println("<div class='error'>Customer ID does not exist.</div>");
                        } else {
                            // Check the status of the last order for this customer
                            String checkOrderStatusSql = "SELECT status FROM laundry_order WHERE customer_id = ? ORDER BY in_date DESC LIMIT 1";
                            pstmt = conn.prepareStatement(checkOrderStatusSql);
                            pstmt.setInt(1, Integer.parseInt(customerId));
                            rs = pstmt.executeQuery();
							
                            boolean temp=true;
                            if (rs.next()) {
                                String lastOrderStatus = rs.getString("status");

                                if ("washed".equals(lastOrderStatus)) {
                                	temp=false;
                                    out.println("<div class='error'>Already Taken.</div>");
                                }else 
                                if ("Not Washed".equals(lastOrderStatus)) {
                                	temp=false;
                                    out.println("<div class='error'>Already Taken.</div>");
                                }
                            }
							if(temp){
	                            // Insert the new order
	                            String sql = "INSERT INTO laundry_order (customer_id, weight, status, in_date) VALUES (?, ?, ?, NOW())";
	                            pstmt = conn.prepareStatement(sql);
	                            pstmt.setInt(1, Integer.parseInt(customerId));
	                            pstmt.setDouble(2, Double.parseDouble(clothWeight));
	                            pstmt.setString(3, status);
	
	                            int rowsAffected = pstmt.executeUpdate();
	                            if (rowsAffected > 0) {
	                                out.println("<div class='success'>Cloth information added successfully!</div>");
	                            } else {
	                                out.println("<div class='error'>Failed to add cloth information.</div>");
	                            }
							}
                        }
                    } catch (Exception e) {
                        out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { }
                    }
                }
            %>

            <a href="staff_dashboard.jsp">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>
