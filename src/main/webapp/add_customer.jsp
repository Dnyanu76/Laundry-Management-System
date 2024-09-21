<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.jsp.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Customer</title>
    <link rel="stylesheet" href="css/add_customer.css">
    <script>
        // JavaScript function to show popup message
        function showPopup(message) {
            alert(message);
        }
    </script>
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
            <h2>Add New Customer</h2>
            <form action="add_customer.jsp" method="post">
                <label for="name">Name</label>
                <input type="text" id="name" name="name" required>

                <label for="mob">Mobile Number</label>
                <input type="text" id="mob" name="mob" pattern="\d{10}" title="Enter a 10-digit mobile number" required>

                <label for="room_no">Room No.</label>
                <input type="text" id="room_no" name="room_no" required>

                <input type="submit" value="Add Customer">
            </form>
        </div>
    </div>

<%  
    String message = null; // To store the popup message

    // Only run this logic when form is submitted
    if(request.getMethod().equalsIgnoreCase("POST")) {

        String name = request.getParameter("name");
        String mob = request.getParameter("mob");
        String room = request.getParameter("room_no");

        String url="jdbc:mysql://localhost:3306/laundry_management";
        String username="root";
        String password1="";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, username, password1);

            String sql = "INSERT INTO `customer` (`name`, `mobile`, `room_no`) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, mob);
            pstmt.setString(3, room);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                message = "Customer added successfully!";
            } else {
                message = "Failed to add customer.";
            }

        } catch (SQLException e) {
            message = "SQLException: " + e.getMessage();
        } catch (ClassNotFoundException e) {
            message = "ClassNotFoundException: " + e.getMessage();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }

        // Show popup message
        if (message != null) {
%>
            <script>
                showPopup("<%= message %>");
            </script>
<%
        }
    }
%>
</body>
</html>
