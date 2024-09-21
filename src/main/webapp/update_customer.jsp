<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.jsp.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update Customer</title>
    <link rel="stylesheet" type="text/css" href="css/update_customer.css">
</head>

<body>
    <div class="container">
        <h1>Update Customer</h1>

        <%
            String customerId = request.getParameter("id"); // Get customer ID from URL
            String name = "";
            String mobile = "";
            String roomNo = "";

            if (customerId != null && !customerId.isEmpty()) {
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    // Load MySQL JDBC Driver
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String url = "jdbc:mysql://localhost:3306/laundry_management";
                    String user = "root";
                    String password = "";
                    conn = DriverManager.getConnection(url, user, password);

                    // Retrieve existing data for the given customer ID
                    String sql = "SELECT `name`, `mobile`, `room_no` FROM customer WHERE `customer_id` = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, Integer.parseInt(customerId));
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        name = rs.getString("name");
                        mobile = rs.getString("mobile");
                        roomNo = rs.getString("room_no");
                    }

                } catch (Exception e) {
                    out.println("<p>Error: Could not retrieve customer details. " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { }
                }
            }
        %>

        <!-- Form to update customer details -->
        <form method="post" action="update_customer.jsp">
            <input type="hidden" name="id" value="<%= customerId %>">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" value="<%= name %>" required>

            <label for="mobile">Mobile Number:</label>
            <input type="text" id="mobile" name="mobile" pattern="\d{10}" title="Enter a 10-digit mobile number" value="<%= mobile %>" required>

            <label for="room_no">Room No.:</label>
            <input type="text" id="room_no" name="room_no" value="<%= roomNo %>" required>

            <input type="submit" value="Update Customer">
        </form>

        <%
            String newName = request.getParameter("name");
            String newMobile = request.getParameter("mobile");
            String newRoomNo = request.getParameter("room_no");

            if (newName != null && newMobile != null && newRoomNo != null && customerId != null) {
                Connection conn = null;
                PreparedStatement pstmt = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String url = "jdbc:mysql://localhost:3306/laundry_management";
                    String user = "root";
                    String password = "";
                    conn = DriverManager.getConnection(url, user, password);

                    // Update customer details in the database
                    String sql = "UPDATE customer SET `name` = ?, `mobile` = ?, `room_no` = ? WHERE `customer_id` = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, newName);
                    pstmt.setString(2, newMobile);
                    pstmt.setString(3, newRoomNo);
                    pstmt.setInt(4, Integer.parseInt(customerId));

                    int rows = pstmt.executeUpdate();
                    if (rows > 0) {
                        out.println("<p class='success'>Customer updated successfully!</p>");
                    } else {
                        out.println("<p class='error'>Failed to update customer.</p>");
                    }

                } catch (Exception e) {
                    out.println("<p class='error'>Error: Could not update the customer.<br>" + e.getMessage() + "</p>");
                } finally {
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { }
                }
            }
        %>
		<br>
        <a href="customer_list.jsp">Back to Customer List</a>
    </div>
</body>
</html>
