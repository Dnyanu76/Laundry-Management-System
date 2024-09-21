<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.jsp.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Staff</title>
    <link rel="stylesheet" href="<%= application.getContextPath() %>/css/staff_dashboard.css">
    
</head>
<body>

<div class="wrapper">
    <!-- Sidebar -->
    <nav class="sidebar">
        <h2>Staff Dashboard</h2>
        <ul>
            <li><a href="take_cloth.jsp">Take Cloth</a></li>
            <li><a href="add_customer.jsp">Create Customer</a></li>
            <li><a href="customer_list.jsp">See Customer List</a></li>
            <li><a href="order_list.jsp">See Orders</a></li>
            <li><a href="index.jsp">log out</a></li>
        </ul>
    </nav>

    <!-- Main content -->
    <div class="main_content">
        <h1>Welcome to the Staff Dashboard</h1>
    </div>
</div>

</body>
</html>