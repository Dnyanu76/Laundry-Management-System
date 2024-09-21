<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.jsp.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer List</title>
    <link rel="stylesheet" href="css/customer_list.css">
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
            <h2>Customer List</h2>
            <!-- Search Form -->
            <form method="get" action="customer_list.jsp" class="search-form">
                <input type="text" name="search" placeholder="Search by name or ID" />
                <input type="submit" value="Search" />
            </form>

            <!-- Customer Table -->
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Mobile</th>
                        <th>Room No</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        String searchQuery = request.getParameter("search");
                        String query = "SELECT * FROM customer";
                        
                        if (searchQuery != null && !searchQuery.isEmpty()) {
                            query += " WHERE name LIKE ? OR customer_id LIKE ?";
                        }

                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/laundry_management", "root", "");

                            pstmt = conn.prepareStatement(query);

                            if (searchQuery != null && !searchQuery.isEmpty()) {
                                pstmt.setString(1, "%" + searchQuery + "%");
                                pstmt.setString(2, "%" + searchQuery + "%");
                            }

                            rs = pstmt.executeQuery();
                            
                            while (rs.next()) {
                                int customerId = rs.getInt("customer_id");
                                String name = rs.getString("name");
                                String mobile = rs.getString("mobile");
                                String roomNo = rs.getString("room_no");
                    %>
                    <tr>
                        <td><%= customerId %></td>
                        <td><%= name %></td>
                        <td><%= mobile %></td>
                        <td><%= roomNo %></td>
                        <td>
                            <a href="update_customer.jsp?id=<%= customerId %>">Update</a> | 
                            <a href="delete_customer.jsp?customer_id=<%= customerId %>" 
                               onclick="return confirm('Are you sure you want to delete this customer?');">Delete</a>
                        </td>
                    </tr>
                    <%
                            }
                        } catch (SQLException | ClassNotFoundException e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
                            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
