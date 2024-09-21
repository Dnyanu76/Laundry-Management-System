<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Orders</title>
    <link rel="stylesheet" href="<%= application.getContextPath() %>/css/customer_dashboard.css">

</head>
<body>

	<a href="index.jsp">Log out</a>
    <div class="order-list">
        <table class="order-table">
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>In Date</th>
                    <th>Out Date</th>
                    <th>Weight (kg)</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                 // No need to declare a new 'session' variable
                String customerId = (String) session.getAttribute("id");
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    if (customerId != null && !customerId.isEmpty()) {
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            String url = "jdbc:mysql://localhost:3306/laundry_management";
                            String user = "root";
                            String password = "";
                            conn = DriverManager.getConnection(url, user, password);

                            String sql = "SELECT * FROM laundry_order WHERE customer_id = ? ORDER BY in_date DESC";
                            pstmt = conn.prepareStatement(sql);
                            pstmt.setInt(1, Integer.parseInt(customerId));
                            rs = pstmt.executeQuery();

                            while (rs.next()) {
                                String orderId = rs.getString("order_id");
                                String inDate = rs.getString("in_date");
                                String outDate = rs.getString("out_date");
                                float weight = rs.getFloat("weight");
                                String status = rs.getString("status");

                                String rowClass = "";
                                if ("Not Washed".equalsIgnoreCase(status)) {
                                    rowClass = "not-washed";
                                } else if ("Washed".equalsIgnoreCase(status)) {
                                    rowClass = "washed";
                                } else if ("Received".equalsIgnoreCase(status)) {
                                    rowClass = "received";
                                }
                %>
                <tr class="<%= rowClass %>">
                    <td><%= orderId %></td>
                    <td><%= inDate %></td>
                    <td><%= outDate != null ? outDate : "N/A" %></td>
                    <td><%= weight %></td>
                    <td><%= status %></td>
                </tr>
                <%
                            }

                        } catch (Exception e) {
                            out.println("Error: " + e.getMessage());
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) { }
                            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                            if (conn != null) try { conn.close(); } catch (SQLException e) { }
                        }
                    } else {
                        out.println("<p>Invalid customer ID.</p>");
                    }
                %>
            </tbody>
        </table>
    </div>

    

</body>
</html>
