<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.jsp.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="<%= application.getContextPath() %>/css/index.css">
    <style>
        .error-message {
            color: red;
            text-align: center;
            margin: 10px 0;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Login</h2>
        <form action="index.jsp" method="post">
            <label for="user_type">Select User Type:</label>
            <select name="user_type" id="user_type" required>
                <option value="Staff">Staff</option>
                <option value="Customer">Customer</option>
            </select>
            
            <label for="id">Enter ID</label>
            <input type="text" name="id" id="id" required/>
            
            <label for="password">Enter password</label>
            <input type="password" name="password" id="password" required/>
            
            <input type="submit" value="Login"/>
            <br>
        </form>
        
        <%
            String user = request.getParameter("user_type");
            String id = request.getParameter("id");
            String password = request.getParameter("password");

            String url = "jdbc:mysql://localhost:3306/laundry_management";
            String username = "root";
            String password1 = "";

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, username, password1);
                
                if ("Staff".equals(user)) {
                    String sql1 = "SELECT * FROM staff WHERE staff_id = ? AND password = ?";
                    pstmt = conn.prepareStatement(sql1);
                    pstmt.setInt(1, Integer.parseInt(id));
                    pstmt.setString(2, password);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        response.sendRedirect("staff_dashboard.jsp");
                    } else {
                        out.println("<div class='error-message'>Invalid username or password. Please try again.</div>");
                    }
                    
                } else if ("Customer".equals(user)) {
                    String sql2 = "SELECT * FROM customer WHERE customer_id = ? AND mobile = ?";
                    pstmt = conn.prepareStatement(sql2);
                    pstmt.setInt(1, Integer.parseInt(id));
                    pstmt.setString(2, password);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        session.setAttribute("id", id);
                        response.sendRedirect("customer_dashboard.jsp");
                    } else {
                        out.println("<div class='error-message'>Invalid username or password. Please try again.</div>");
                    }
                }
            } catch (SQLException e) {
                out.println("SQLException: " + e.getMessage() + "<br>");
                for (StackTraceElement element : e.getStackTrace()) {
                    out.println(element.toString() + "<br>");
                }
            } catch (ClassNotFoundException e) {
                out.println("ClassNotFoundException: " + e.getMessage() + "<br>");
                for (StackTraceElement element : e.getStackTrace()) {
                    out.println(element.toString() + "<br>");
                }
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                if (conn != null) try { conn.close(); } catch (SQLException e) { }
            }
        %>
    </div>
</body>
</html>
