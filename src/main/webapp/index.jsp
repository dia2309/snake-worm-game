<%@ page session="true" %>
<%
    if (session.getAttribute("user_id") != null) {
        response.sendRedirect("game.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Snake Game Login</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-box { background: #fff; padding: 20px 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); width: 300px; }
        .login-box h2 { text-align: center; color: #333; }
        .form-group { margin-bottom: 15px; display: flex; flex-direction: column; }
        .form-group label { margin-bottom: 5px; font-weight: bold; }
        .form-group input { padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        .btn { padding: 10px; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; width: 100%; font-size: 16px;}
        .btn:hover { background-color: #218838; }
        .error { color: red; font-size: 0.9em; text-align: center;}
    </style>
    <script>
        function validateForm() {
            let u = document.forms["loginForm"]["username"].value;
            let p = document.forms["loginForm"]["password"].value;
            if (u === "" || p === "") {
                alert("Username and Password must be filled out!");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
<div class="login-box">
    <h2>Login</h2>
    <% if(request.getAttribute("error") != null) { %>
    <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>
    <form name="loginForm" action="LoginServlet" method="POST" onsubmit="return validateForm()">
        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username">
        </div>
        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password">
        </div>
        <button type="submit" class="btn">Login</button>
    </form>
</div>
</body>
</html>