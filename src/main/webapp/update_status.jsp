<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.jsp.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update Order</title>
    <link rel="stylesheet" type="text/css" href="css/update_status.css">
    <script>
        // JavaScript function to set the current date to the input field
        function setCurrentDate() {
            var today = new Date();
            var day = String(today.getDate()).padStart(2, '0');
            var month = String(today.getMonth() + 1).padStart(2, '0'); // January is 0!
            var year = today.getFullYear();

            today = year + '-' + month + '-' + day;
            document.getElementById('out_date').value = today;
        }

        window.onload = setCurrentDate; // Call function on page load
    </script>
</head>
<body>
    <div class="container">
        <h1>Update Order</h1>

        <%
            String id = request.getParameter("id");
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            String orderId = "";
            String customerId = "";
            String status = "";
            
            if (id != null && !id.isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String url = "jdbc:mysql://localhost:3306/laundry_management";
                    String user = "root";
                    String password = "";
                    conn = DriverManager.getConnection(url, user, password);

                    // Retrieve existing order data
                    String sql = "SELECT * FROM laundry_order WHERE order_id = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, Integer.parseInt(id));
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        orderId = rs.getString("order_id");
                        customerId = rs.getString("customer_id");
                        status = rs.getString("status");
                    } else {
                        out.println("<p>Order not found.</p>");
                    }

                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { }
                }
            }
        %>

        <form method="post" action="update_status.jsp">
            <input type="hidden" name="id" value="<%= id %>">
            <label for="order_id">Order ID:</label>
            <input type="text" id="order_id" name="order_id" value="<%= orderId %>" readonly><br><br>

            <label for="customer_id">Customer ID:</label>
            <input type="text" id="customer_id" name="customer_id" value="<%= customerId %>" readonly><br><br>

            <label for="status">Current Status:</label>
            <input type="text" id="status" name="status" value="<%= status %>" readonly><br><br>

            <label for="update_action">Update Status:</label>
            <select id="update_action" name="update_action">
                <% if ("Not Washed".equalsIgnoreCase(status)) { %>
                    <option value="washed">Mark as Washed</option>
                <% } %>
                <% if ("washed".equalsIgnoreCase(status)) { %>
                    <option value="received">Mark as Received</option>
                <% } %>
            </select>

            
                <input type="text" id="update_action1" name="update_action1" value="update_out_date" required hidden>
                <input type="date" id="out_date" name="out_date" required hidden>
 
            <input type="submit" value="Update Order">
        </form>

        <%
            String action = request.getParameter("update_action");
        	String action_date = request.getParameter("update_action1");
            String newOutDate = request.getParameter("out_date");

            if (action != null && id != null) {
                

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String url = "jdbc:mysql://localhost:3306/laundry_management";
                    String user = "root";
                    String password = "";
                    conn = DriverManager.getConnection(url, user, password);

                    if ("washed".equals(action)) {
                        String sql = "UPDATE laundry_order SET status = 'washed' WHERE order_id = ?";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setInt(1, Integer.parseInt(id));
                        int rows = pstmt.executeUpdate();
                        if (rows > 0) {
                            out.println("<div class='success'>Status updated to Washed.</div>");
                        } else {
                            out.println("<div class='error'>Failed to update status.</div>");
                        }
                    } else if ("received".equals(action)) {
                        String sql = "UPDATE laundry_order SET status = 'received',out_date = ? WHERE order_id = ?";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setDate(1, java.sql.Date.valueOf(newOutDate));
                        pstmt.setInt(2, Integer.parseInt(id));
                        int rows = pstmt.executeUpdate();
                        if (rows > 0) {
                            out.println("<div class='success'>Status updated to Received.</div>");
                        } else {
                            out.println("<div class='error'>Failed to update status.</div>");
                        }
                    } 
                } catch (Exception e) {
                    out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
                } finally {
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { }
                }
            }
        %>

        <a href="order_list.jsp">Back to Order List</a>
    </div>
</body>
</html>
