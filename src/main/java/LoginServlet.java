import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //get the user input from index.jsp
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/snake_game", "root", "");
            //get the user id and prevent SQL injection
            PreparedStatement ps = conn.prepareStatement("SELECT id FROM users WHERE username=? AND password=?");
            ps.setString(1, user);
            ps.setString(2, pass);
            //execute the select query
            ResultSet rs = ps.executeQuery();

            //create a new session if the user exists
            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("user_id", rs.getInt("id"));
                session.setAttribute("username", user);
                response.sendRedirect("game.jsp");
            } else {
                request.setAttribute("error", "Invalid Credentials");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}