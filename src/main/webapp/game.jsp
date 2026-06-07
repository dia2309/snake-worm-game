<%@ page session="true" %>
<%
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Snake Game</title>
    <style>
        body { text-align: center; font-family: Arial, sans-serif; background: #eee; }
        canvas { background: #fff; border: 2px solid #333; box-shadow: 0 4px 8px rgba(0,0,0,0.2); }
        .nav { padding: 10px; background: #333; color: white; margin-bottom: 20px;}
        .nav a { color: #ffeb3b; text-decoration: none; margin-left: 20px;}
    </style>
</head>
<body>
<div class="nav">
    Welcome, <%= session.getAttribute("username") %>!
    <a href="LogoutServlet" onclick="return confirm('Are you sure you want to exit?')">Logout</a>
</div>

<button onclick="startGame()" style="padding: 10px 20px; margin-bottom: 10px; font-size: 16px;">Start Game</button>
<br>
<canvas id="gameCanvas" width="400" height="400"></canvas>

<script>
    const canvas = document.getElementById("gameCanvas");
    const ctx = canvas.getContext("2d");
    const gridSize = 20; //20px blocks
    let snake = [];
    let dx = gridSize; //move right
    let dy = 0;
    let food = {x: 100, y: 100};
    let obstacles = [{x: 200, y: 200}, {x: 220, y: 200}, {x: 200, y: 220}];
    let gameLoop;
    let gameActive = false;

    document.addEventListener("keydown", changeDirection);

    function startGame() {
        if(gameActive) return;
        snake = [{x: 40, y: 40}, {x: 20, y: 40}]; //initial snake body
        dx = gridSize; dy = 0;
        gameActive = true;

        fetch('GameLogicServlet?action=start', {method: 'POST'});

        if(gameLoop) clearInterval(gameLoop);
        gameLoop = setInterval(update, 250);
    }

    function update() {
        const head = {x: snake[0].x + dx, y: snake[0].y + dy};

        if (head.x < 0 || head.x >= canvas.width || head.y < 0 || head.y >= canvas.height) return gameOver();

        for (let part of snake) if (head.x === part.x && head.y === part.y) return gameOver();
        for (let obs of obstacles) if (head.x === obs.x && head.y === obs.y) return gameOver();

        //add a new head at the front
        snake.unshift(head);

        fetch('GameLogicServlet?action=move&x=' + head.x + '&y=' + head.y, {method: 'POST'});

        //if it ate, move the food
        if (head.x === food.x && head.y === food.y) {
            food = {
                x: Math.floor(Math.random() * (canvas.width / gridSize)) * gridSize,
                y: Math.floor(Math.random() * (canvas.height / gridSize)) * gridSize
            };
        } // if it didnt eat, delete the last block of snake
        else {
            snake.pop();
        }
        draw();
    }

    function draw() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        ctx.fillStyle = "green";
        ctx.fillRect(food.x, food.y, gridSize, gridSize);

        ctx.fillStyle = "red";
        for (let obs of obstacles) ctx.fillRect(obs.x, obs.y, gridSize, gridSize);

        ctx.fillStyle = "blue";
        for (let part of snake) {
            ctx.fillRect(part.x, part.y, gridSize, gridSize);
            ctx.strokeRect(part.x, part.y, gridSize, gridSize);
        }
    }

    function changeDirection(event) {
        const LEFT_KEY = 37; const RIGHT_KEY = 39; const UP_KEY = 38; const DOWN_KEY = 40;
        const keyPressed = event.keyCode;
        if (keyPressed === LEFT_KEY && dx !== gridSize) { dx = -gridSize; dy = 0; }
        if (keyPressed === UP_KEY && dy !== gridSize) { dx = 0; dy = -gridSize; }
        if (keyPressed === RIGHT_KEY && dx !== -gridSize) { dx = gridSize; dy = 0; }
        if (keyPressed === DOWN_KEY && dy !== -gridSize) { dx = 0; dy = gridSize; }
    }

    function gameOver() {
        gameActive = false;
        clearInterval(gameLoop);
        alert("Game Over!");
        fetch('GameLogicServlet?action=end', {method: 'POST'});
    }
</script>
</body>
</html>