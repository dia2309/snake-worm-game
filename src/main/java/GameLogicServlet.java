import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/GameLogicServlet")
public class GameLogicServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) return;

        String action = request.getParameter("action");
        int userId = (Integer) session.getAttribute("user_id");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/snake_game", "root", "");

            if ("start".equals(action)) {
                PreparedStatement ps = conn.prepareStatement("INSERT INTO games (user_id, start_time) VALUES (?, NOW())", Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, userId);
                ps.executeUpdate();

                ResultSet rs = ps.getGeneratedKeys();
                if(rs.next()) {
                    session.setAttribute("current_game_id", rs.getInt(1));
                    session.setAttribute("start_time_millis", System.currentTimeMillis());
                }
            }
            else if ("move".equals(action)) {
                if (session.getAttribute("current_game_id") != null) {
                    int gameId = (Integer) session.getAttribute("current_game_id");
                    int x = Integer.parseInt(request.getParameter("x"));
                    int y = Integer.parseInt(request.getParameter("y"));

                    PreparedStatement ps = conn.prepareStatement("INSERT INTO moves (game_id, pos_x, pos_y) VALUES (?, ?, ?)");
                    ps.setInt(1, gameId);
                    ps.setInt(2, x);
                    ps.setInt(3, y);
                    ps.executeUpdate();
                }
            }
            else if ("end".equals(action)) {
                if (session.getAttribute("current_game_id") != null) {
                    int gameId = (Integer) session.getAttribute("current_game_id");
                    long startMillis = (Long) session.getAttribute("start_time_millis");
                    long durationSeconds = (System.currentTimeMillis() - startMillis) / 1000;

                    PreparedStatement ps = conn.prepareStatement("UPDATE games SET duration_seconds = ? WHERE id = ?");
                    ps.setLong(1, durationSeconds);
                    ps.setInt(2, gameId);
                    ps.executeUpdate();

                    session.removeAttribute("current_game_id");
                    session.removeAttribute("start_time_millis");
                }
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}