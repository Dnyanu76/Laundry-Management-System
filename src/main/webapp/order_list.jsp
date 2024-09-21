<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.jsp.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order List</title>
    <link rel="stylesheet" type="text/css" href="css/orders_list.css">
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
        <br>
        	<hr>
            <h1>Order List</h1>
			<hr>
			<br>
            <!-- Search by Customer ID -->
            <form method="get" action="order_list.jsp">
                <label for="customer_id">Search by Customer ID:</label>
                <input type="text" id="customer_id" name="customer_id">
                <input type="submit" value="Search">
            </form>

            <!-- Sort by Status -->
            <form method="get" action="order_list.jsp">
                <label for="status">Sort by Status:</label>
                <select id="status" name="status">
                    <option value="">All</option>
                    <option value="Not Washed">Not Washed</option>
                    <option value="washed">Washed</option>
                    <option value="received">received</option>
                </select>
                <input type="submit" value="Sort">
            </form>

            <!-- Order Table -->
            <table>
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer ID</th>
                        <th>Weight (kg)</th>
                        <th>Status</th>
                        <th>In Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        String customerId = request.getParameter("customer_id");
                        String status = request.getParameter("status");

                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            String url = "jdbc:mysql://localhost:3306/laundry_management";
                            String user = "root";
                            String password = "";
                            conn = DriverManager.getConnection(url, user, password);

                            StringBuilder sql = new StringBuilder("SELECT * FROM laundry_order WHERE 1=1");

                            if (customerId != null && !customerId.isEmpty()) {
                                sql.append(" AND customer_id = ?");
                            }

                            if (status != null && !status.isEmpty()) {
                                sql.append(" AND status = ?");
                            }

                            pstmt = conn.prepareStatement(sql.toString());

                            int index = 1;
                            if (customerId != null && !customerId.isEmpty()) {
                                pstmt.setInt(index++, Integer.parseInt(customerId));
                            }

                            if (status != null && !status.isEmpty()) {
                                pstmt.setString(index++, status);
                            }

                            rs = pstmt.executeQuery();

                            while (rs.next()) {
                                int orderId = rs.getInt("order_id");
                                int custId = rs.getInt("customer_id");
                                double weight = rs.getDouble("weight");
                                String orderStatus = rs.getString("status");
                                java.sql.Date inDate = rs.getDate("in_date");
                    %>
                                <tr>
                                    <td><%= orderId %></td>
                                    <td><%= custId %></td>
                                    <td><%= weight %></td>
                                    <td><%= orderStatus %></td>
                                    <td><%= inDate %></td>
                                    <td>
                                        <a href="update_status.jsp?id=<%= orderId %>">Update</a> |
                                        <a href="order_details.jsp?id=<%= orderId %>">Detail</a>
                                    </td>
                                </tr>
                    <% 
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6' class='error'>Error: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) { }
                            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                            if (conn != null) try { conn.close(); } catch (SQLException e) { }
                        }
                    %>
                </tbody>
            </table>

        </div>
    </div>
</body>
</html>
