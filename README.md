# Java Full-Stack Snake Game

A classic Snake game built from scratch to demonstrate full-stack web development. This project features a custom-built HTML5/JS game engine communicating asynchronously with a secure Java Servlet backend and a MySQL database.

## Tech Stack
* **Frontend:** HTML5 Canvas, CSS3, Vanilla JavaScript (AJAX/Fetch API)
* **Backend:** Java, JSP, Servlets, Apache Tomcat
* **Database:** MySQL, JDBC

## Features
* **Custom Game Engine:** Hand-coded grid movement, collision detection, and array-based snake growth.
* **Asynchronous Communication:** The frontend game loop continuously sends coordinate data to the Java server via `fetch()` without ever reloading the page.
* **User Authentication:** Secure login system using JSP and Java Sessions to track active players.
* **Database Tracking:** All game sessions, exact movement coordinates, and final durations are logged into MySQL.

## How to Run Locally
1. Clone this repository.
2. Set up a MySQL database named `snake_game` and import the tables (users, games, moves).
3. Open the project in IntelliJ IDEA (Enterprise) or Eclipse.
4. Configure an Apache Tomcat Server and deploy the artifact.
5. Navigate to `http://localhost:8080/snake_game` to play!
