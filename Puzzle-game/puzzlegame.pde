//
// SCIE204 - Assignment 4, Puzzle Game
// Mahtab Foroozandeh
// Email: mforoozandehshahraki@ecuad.ca
// 11/25/2024
//
// This program implements a puzzle game where the player arranges missing pieces, in specific order, into a grid while avoiding enemies. 
// The game includes moving and static enemies, a timer, and a win/lose condition. The player can pause, reset, or win the game.
// I wrote all the codes in this file



///////////////////////////
// Constants
int gridSize = 5; // Puzzle grid size (5x5)
int tileSize = 50; // Size of each tile
int collisionThreshold = 30; // Distance threshold for collision detection
int timeLimit = 45; // Time limit in seconds
int numMovingEnemies = 4; // Number of moving enemies
int numStaticEnemies = 4; // Number of stationary enemies
int gameStartTime; // Time when the game starts
int fc = 0; // Frame counter

// Game Variables
int[][] puzzle; // The puzzle grid
PVector[] missingPieces; // Missing pieces' positions in the grid
PVector[] piecePositions; // Positions of draggable pieces
boolean[] piecePlaced; // Tracks if a piece is placed
int draggingPiece = -1; // Index of the piece being dragged
int currentPieceIndex = 0; // Index of the piece that must be placed next
int startTime; // Game start time
boolean isRunning = false; // Game running state
boolean gameOver = false; // Game over state

// Player Variables
PVector playerPos; // Player position
PImage playerImage; // Player image

// Enemy Variables
PVector[] movingEnemies; // Positions of moving enemies
PVector[] staticEnemies; // Positions of stationary enemies
float[] movingEnemySpeeds; // Speed for each moving enemy

// Visual Assets
PImage puzzleImage;
PImage movingEnemyImage;
PImage staticEnemyImage;
PImage bg;

// Function to generate a random position within specified bounds
PVector generateRandomPosition(float minX, float maxX, float minY, float maxY)
{
    float x = random(minX + 112, maxX - 112); // Ensure 112 pixels from horizontal edges
    float y = random(minY + 112, maxY - 112); // Ensure 112 pixels from vertical edges
    return new PVector(x, y);
}

// Function to check if all pieces are placed
boolean checkAllPiecesPlaced() 
{
    for (boolean placed : piecePlaced) 
    {
        if (!placed) 
        {
            return false; // If any piece is not placed, return false
        }
    }
    return true; // All pieces are placed
}




/////////////////////////
//
// Setup Function
void setup() {
    surface.setTitle("SCIE204, Mahtab Foroozandeh, Assignment 4"); // Change app's name in the titlebar
    size(1000, 720); // Set canvas size
    puzzleImage = loadImage("image.jpg"); // Load the puzzle image
    puzzleImage.resize(gridSize * tileSize, gridSize * tileSize); // Resize image to fit puzzle grid
    movingEnemyImage = loadImage("moving_enemy.png"); // Load moving enemy image
    staticEnemyImage = loadImage("static_enemy.png"); // Load static enemy image
    playerImage = loadImage("player.png"); // Load the player image
    bg =loadImage("bg.jpg");
    
    // Resize images for consistency
    movingEnemyImage.resize(tileSize, tileSize);
    staticEnemyImage.resize(tileSize, tileSize);
    playerImage.resize(40, 40); // Smaller player image for visibility

    resetGame(); // Initialize the game state
}





// Main game loop to draw elements and update game state
void draw() {
  background(#CEFFED); // light green background
image(bg, 0, 0, width, height);

  if (!gameOver) {
    drawPuzzle(); // Draw the puzzle
    drawPieces(); // Draw draggable pieces
    drawEnemies(); // Draw all enemies
    drawPlayer(); // Draw the player (follows mouse with easing)

    if (isRunning) {
      movePlayer(); // Move player with easing
      moveEnemies(); // Move the moving enemies
      checkCollisions(); // Check for collisions with enemies and puzzle
      checkTime(); // Check if time has run out
      checkWinCondition(); // Check if the puzzle is complete
    }
  } else {
    showGameOver(); // Display the game over screen
  }
}





// Initialize and Reset the Game
void resetGame() 
{
  // Initialize puzzle grid
  puzzle = new int[gridSize][gridSize];
  int counter = 1;
  for (int i = 0; i < gridSize; i++) 
  {
    for (int j = 0; j < gridSize; j++) 
    {
      puzzle[i][j] = counter++;
    }
  }

  // Set missing pieces
  missingPieces = new PVector[] 
  { 
    //coordinates of missing pieces
    new PVector(0, 0),
    new PVector(1, 1),
    new PVector(2, 2),
    new PVector(3, 4)
  };
  
  piecePositions = new PVector[missingPieces.length];
  piecePlaced = new boolean[missingPieces.length];

  // Mark missing pieces in the puzzle
  for (PVector piece : missingPieces) 
  {
    puzzle[(int) piece.x][(int) piece.y] = 0;
  }

  // Place missing pieces in a column on the right
  for (int i = 0; i < piecePositions.length; i++) 
  {
    piecePositions[i] = new PVector(width - tileSize - 112, 230 + i * (tileSize + 10));
  }

  // Initialize player position
  playerPos = new PVector(width / 2, height / 2);

  // Initialize enemies
  initializeEnemies();

  // Reset game state
  currentPieceIndex = 0;
  draggingPiece = -1;
  isRunning = false;
  gameOver = false;
  gameStartTime = millis();// Timer for the game
  startTime = millis();
  
  fc = 0;// Reset the frame counter when the game is reset
  println ("Game Rest");
  
}




//Initializes the positions and speeds of static and moving enemies.
void initializeEnemies() 
{
    println("Initializing enemies...");// Print a message to indicate the initialization of enemies

    // Initialize the array to hold static enemy positions
    staticEnemies = new PVector[numStaticEnemies]; // Create an array for static enemies

    // Loop through each static enemy to assign its position
    for (int i = 0; i < numStaticEnemies; i++) 
    {
        staticEnemies[i] = generateStaticEnemyPosition(); // Generate a valid random position for the enemy
        println("Static enemy " + i + ": " + staticEnemies[i]); // Log the position of each static enemy
    }

    // Initialize the array to hold moving enemy positions
    movingEnemies = new PVector[numMovingEnemies]; // Create an array for moving enemies

    // Initialize the array to hold moving enemy speeds
    movingEnemySpeeds = new float[numMovingEnemies * 2]; // Two values per enemy: X-speed and Y-speed

    // Assign initial positions for moving enemies at the four corners of the canvas
    movingEnemies[0] = new PVector(50, 50); // Top-left corner
    movingEnemies[1] = new PVector(width - 50, 50); // Top-right corner
    movingEnemies[2] = new PVector(50, height - 50); // Bottom-left corner
    movingEnemies[3] = new PVector(width - 50, height - 50); // Bottom-right corner

    // Loop through each moving enemy to assign random speeds
    for (int i = 0; i < numMovingEnemies; i++) 
    {
        // Assign a random X speed between 2 and 4, with a random direction
        movingEnemySpeeds[i * 2] = random(2, 4) * (random(1) > 0.5 ? 1 : -1);

        // Assign a random Y speed between 2 and 4, with a random direction
        movingEnemySpeeds[i * 2 + 1] = random(2, 4) * (random(1) > 0.5 ? 1 : -1);

        // Log the initial position and speed of each moving enemy
        println("Moving enemy " + i + " initial position: " + movingEnemies[i] +
                ", Speed: (" + movingEnemySpeeds[i * 2] + ", " + movingEnemySpeeds[i * 2 + 1] + ")");
    }
}





// Generate Static Enemy Position in the Defined Region
PVector generateStaticEnemyPosition() 
{
  float puzzleRight = (width / 4 - gridSize * tileSize / 2) + gridSize * tileSize; // Right edge of the puzzle
  float draggableLeft = width - tileSize * 3.5; // Left edge of draggable pieces
  float verticalStart = height / 2 - gridSize * tileSize / 2; // Top edge of the puzzle grid
  float verticalEnd = height / 2 + gridSize * tileSize / 2;  // Bottom edge of the puzzle grid

  // Generate random position in the defined region
  float x = random(puzzleRight + 20, draggableLeft - 20); // Horizontal space between puzzle and pieces
  float y = random(verticalStart, verticalEnd);           // Vertical range matching puzzle grid

  return new PVector(x, y);
}




// Generate Moving Enemy Position (Separate Function for Flexibility)
PVector generateEnemyPosition() 
{
  float puzzleRight = (width / 5 - gridSize * tileSize / 2) + gridSize * tileSize; // Right edge of the puzzle
  float draggableLeft = width - tileSize * 2; // Left edge of draggable pieces
  float verticalStart = height / 2 - gridSize * tileSize / 2; // Top edge of the puzzle grid
  float verticalEnd = height / 2 + gridSize * tileSize / 2;  // Bottom edge of the puzzle grid

  // Generate random position in the defined region
  float x = random(puzzleRight + 20, draggableLeft - 20); // Horizontal space between puzzle and pieces
  float y = random(verticalStart, verticalEnd); // Vertical range matching puzzle grid

  return new PVector(x, y);
}





//Draws the puzzle grid and tiles on the canvas.
void drawPuzzle() 
{
    float offsetX = width / 4 - gridSize * tileSize / 2; // Calculate horizontal offset to center the puzzle grid on the canvas 
    float offsetY = height / 2 - gridSize * tileSize / 2; // Calculate vertical offset to center the puzzle grid on the canvas

    // Loop through each row of the grid
    for (int i = 0; i < gridSize; i++) 
    {
        // Loop through each column of the grid
        for (int j = 0; j < gridSize; j++) 
        {
            float x = offsetX + i * tileSize; // Calculate the x-coordinate for the top-left corner of the current grid cell
            float y = offsetY + j * tileSize; // Calculate the y-coordinate for the top-left corner of the current grid cell

            stroke(0); // Set the stroke color for the grid cell outline
            fill(200);  // Set the fill color for the grid cell background 
            rect(x, y, tileSize, tileSize);// Draw a rectangle representing the current grid cell 

            // Check if the current grid cell contains a non-empty tile
            if (puzzle[i][j] != 0) 
            {
                PImage tileImage = puzzleImage.get(i * tileSize, j * tileSize, tileSize, tileSize); // Extract the corresponding tile image from the puzzle image
                image(tileImage, x, y, tileSize, tileSize); // Draw the tile image in the current grid cell
            }
        }
    }
}





//Draws the draggable puzzle pieces on the canvas.
void drawPieces() 
{
    // Loop through each missing piece
    for (int i = 0; i < missingPieces.length; i++) 
    {
        // Check if the piece is not yet placed on the grid
        if (!piecePlaced[i]) 
        {
            fill(i == currentPieceIndex ? color(0, 255, 0) : color(150, 0, 0));// Set the fill color for the draggable piece: green for the current piece, red for others
            rect(piecePositions[i].x, piecePositions[i].y, tileSize, tileSize);// Draw the rectangle representing the piece, at the given position 

            PVector gridPosition = missingPieces[i];// Get the grid position of the missing piece in the puzzle 
            PImage pieceImage = puzzleImage.get((int) gridPosition.x * tileSize, (int) gridPosition.y * tileSize, tileSize, tileSize);// Extract the corresponding tile image from the puzzle image (based on grid position) 
            image(pieceImage, piecePositions[i].x, piecePositions[i].y, tileSize, tileSize);// Draw the extracted piece image at the piece's current position
        }
    }
}







//Draws both static and moving enemies on the screen.
void drawEnemies() 
{
    // Draw static enemies (rocks)
    // Loop through each static enemy (rock) in the staticEnemies array
    for (PVector rock : staticEnemies) 
    {
        image(staticEnemyImage, rock.x - tileSize / 2, rock.y - tileSize / 2); // Draw the static enemy image at its position, adjusting for center alignment with the tile size 
    }

    // Draw moving enemies
    // Loop through each moving enemy in the movingEnemies array
    for (PVector enemy : movingEnemies) 
    {        
        image(movingEnemyImage, enemy.x - tileSize / 2, enemy.y - tileSize / 2); // Draw the moving enemy image at its current position, adjusting for center alignment with the tile size
    }
}





//Draws the player image at the players current position
void drawPlayer() 
{
  image(playerImage, playerPos.x - playerImage.width / 2, playerPos.y - playerImage.height / 2);  // Draw the player image at its current position, adjusting for center alignment with the image dimensions
}





//Moves the player towards the mouse position with easing effect
void movePlayer() 
{
  float easing = 0.09; //controls the smoothness of the movement
  
  playerPos.x += (mouseX - playerPos.x) * easing;// Move the player along the X axis with easing effect

  playerPos.y += (mouseY - playerPos.y) * easing;// Move the player along the Y axis with easing effect
}





// Moves the enemies based on their speed, and makes them bounce off the edges of the canvas.
void moveEnemies() 
{
  // Check if the game is paused; if it is, do not move enemies
  if (!isRunning) return; // Do not move enemies if the game is paused
  
  // Check if 3.2 seconds have passed since the game started; if not, do not move enemies
  if (millis() - gameStartTime < 3200) return; // Check if 3.2 seconds have passed since the game started

  // Iterate through each moving enemy to update their position
  for (int i = 0; i < movingEnemies.length; i++)
  {
    // Update the position of the current enemy based on its speed
    movingEnemies[i].x += movingEnemySpeeds[i * 2]; // Update X position using the X speed
    movingEnemies[i].y += movingEnemySpeeds[i * 2 + 1]; // Update Y position using the Y speed

    // Bounce enemies off the left and right edges of the canvas
    if (movingEnemies[i].x < 50 || movingEnemies[i].x > width - 50) 
    {
      movingEnemySpeeds[i * 2] *= -1; // Reverse the X direction if the enemy reaches the left or right edge
    }

    // Bounce enemies off the top and bottom edges of the canvas
    if (movingEnemies[i].y < 50 || movingEnemies[i].y > height - 50)
    {
      movingEnemySpeeds[i * 2 + 1] *= -1; // Reverse the Y direction if the enemy reaches the top or bottom edge
    }
  }
}





// Handles mouse input for starting to drag pieces or toggling the game state.
void mousePressed() 
{
  // Check if the left mouse button was pressed and the game is running
  if (mouseButton == LEFT && isRunning) 
  {
    // Check if the game is running
    if (isRunning) 
    {
      // Check if the player clicked on the current draggable piece
      if (!piecePlaced[currentPieceIndex] && overPiece(piecePositions[currentPieceIndex])) 
      {
        draggingPiece = currentPieceIndex; // Start dragging the current piece
        println("Started dragging piece: " + (currentPieceIndex + 1)); // Print which piece is being dragged
      }
    } 
    // If the game is paused
    else 
    {
      isRunning = !isRunning; // Toggle the game state (running or paused)
      
      // If the game is now running and it hasn't started yet (gameStartTime == 0)
      if (isRunning && gameStartTime == 0) 
      {
        gameStartTime = millis(); // Record the game start time when the game is resumed
      }
    }
  }
}





//Handles the dragging of a puzzle piece when the mouse is moved while a piece is being dragged.
void mouseDragged() 
{
  // Check if a piece is currently being dragged (draggingPiece is not -1)
  if (draggingPiece != -1)
  {
    // Update the position of the dragged piece to follow the mouse's current position
    piecePositions[draggingPiece].x = mouseX - tileSize / 2;  // Set the X position to the mouse X position, adjusted by half the tile size to center the piece
    piecePositions[draggingPiece].y = mouseY - tileSize / 2;  // Set the Y position to the mouse Y position, adjusted similarly for centering
  }
}




//Handles actions when the mouse button is released, such as dropping a dragged puzzle piece,
//toggling the game state, or resetting the game on a right-click.
void mouseReleased() 
{
  // Check if the left mouse button was released
  if (mouseButton == LEFT) 
  {
    // Check if a piece is being dragged (draggingPiece is not -1)
    if (draggingPiece != -1) 
    {
      // Define the target position for the dropped piece, based on the current missing piece's position
      PVector targetPos = missingPieces[draggingPiece];
      float offsetX = width / 4 - gridSize * tileSize / 2; // Calculate offset to center the grid on the screen
      float offsetY = height / 2 - gridSize * tileSize / 2; // Calculate the vertical offset
      float targetX = offsetX + targetPos.x * tileSize; // Target X position in the grid
      float targetY = offsetY + targetPos.y * tileSize; // Target Y position in the grid

      // Check if the piece is placed near its target position (within half the tile size distance)
      if (dist(piecePositions[draggingPiece].x, piecePositions[draggingPiece].y, targetX, targetY) < tileSize / 2) 
      {
        // Snap the piece to the target position and mark it as placed
        piecePositions[draggingPiece] = new PVector(targetX, targetY); // Set piece position to target
        piecePlaced[draggingPiece] = true; // Mark the piece as placed
        puzzle[(int) targetPos.x][(int) targetPos.y] = (int) (targetPos.x * gridSize + targetPos.y + 1); // Update puzzle grid with the placed piece
        currentPieceIndex++; // Move to the next piece in the sequence
        println("Placed piece: " + currentPieceIndex); // Print which piece was placed correctly
      }

      // Stop dragging the piece (reset draggingPiece to -1)
      draggingPiece = -1; 
    } 
    else 
    {
      // If no piece is being dragged, toggle the game state (paused or running)
      if (!gameOver) 
      {
        isRunning = !isRunning; // Toggle the isRunning boolean variable (game running or paused)
        if (isRunning) 
        {
          println("Game Resumed"); // Print when the game is resumed
        } 
        else 
        {
          println("Game Paused"); // Print when the game is paused
        }
      }
    }
  } 
  // Check if the right mouse button was released
  else if (mouseButton == RIGHT) 
  {
    resetGame(); // Call the resetGame function to restart the game when the right button is released
  }
}






 //Checks if the mouse pointer is over a specific puzzle piece.
 //piece (PVector) - the position of the piece to check against.
 //boolean - returns true if the mouse is over the piece, false otherwise.
boolean overPiece(PVector piece) 
{
  // Check if the mouse's X-coordinate is within the horizontal bounds of the piece
  return mouseX > piece.x && mouseX < piece.x + tileSize &&
         // Check if the mouse's Y-coordinate is within the vertical bounds of the piece
         mouseY > piece.y && mouseY < piece.y + tileSize;
}





//Checks for collisions between the player and static enemies (rocks).
//The function ends the game if the player collides with any static enemy.
void checkCollisions() 
{
  // Loop through each static enemy (rock) in the staticEnemies array
  for (PVector rock : staticEnemies) 
  {
    // Check if the distance between the player and the current rock is smaller than the collision threshold
    if (dist(playerPos.x, playerPos.y, rock.x, rock.y) < collisionThreshold) 
    {
      gameOver = true; // Set gameOver to true if a collision is detected
      isRunning = false; // Stop the game by setting isRunning to false
      println("Game Over: Player hit a static enemy."); // Output a message indicating the game is over
      return; // Exit the function early as we don't need to check for further collisions
    }
  }

  // Check collisions with moving enemies
  for (PVector enemy : movingEnemies) 
  {  
    // Check if the distance between the player and the cloud is smaller than the collision threshold
    if (dist(playerPos.x, playerPos.y, enemy.x, enemy.y) < collisionThreshold) 
    {
      gameOver = true; // Game over on hitting a moving enemy
      isRunning = false; // Stop the game
      println("Game Over: Player hit a moving enemy.");
      return; // No need to check further
    }
  }
}





//Calculates and displays the elapsed time and checks if the game has exceeded the time limit.
//If the time exceeds the time limit, the game ends.
void checkTime() 
{
  // Calculate the elapsed time in seconds by subtracting the start time from the current time (in milliseconds),
  // then dividing by 1000 to convert to seconds.
  int elapsedTime = (millis() - startTime) / 1000;

  fill(0); // Set the text color to black
  textSize(22); // Set the font size for the displayed time text
  textAlign(LEFT, TOP); // Align the text to the top-left corner of the screen

  // Display the countdown timer on the screen at position (10, 10). The time left is calculated by subtracting
  // the elapsed time from the timeLimit. Use max(0, timeLimit - elapsedTime) to ensure the timer never goes negative.
  text("Time: " + max(0, timeLimit - elapsedTime), 10, 10);

  // If the elapsed time exceeds the time limit, end the game
  if (elapsedTime >= timeLimit) 
  {
    gameOver = true; // Set gameOver to true indicating the game has ended due to time limit
    isRunning = false; // Stop the game by setting isRunning to false
    println("Game Over: Time's up."); // Print a message to the console indicating that time has run out
  }
}





// Display Game Over Screen
void showGameOver() {
  background(200, 0, 0); // Red background for game over
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(32);
  text("Game Over", width / 2, height / 2); // Show game over message
  textSize(16);
  text("Press RIGHT Mouse Button to Reset", width / 2, height / 2 + 40); // Reset instruction
}





//Checks whether all puzzle pieces have been placed. If all pieces are placed, the game is marked as won.
void checkWinCondition() 
{
  boolean allPlaced = true; // Assume all pieces are placed until proven otherwise
  // Iterate through each element in the 'piecePlaced' array to check if all pieces are placed
  for (boolean placed : piecePlaced) 
  {
    if (!placed) 
    { // If any piece is not placed
      allPlaced = false; // Set the 'allPlaced' flag to false
      break; // Exit the loop early since we already know the game is not won
    }
  }

  // If all pieces are placed correctly, the player wins the game
  if (allPlaced) 
  {
    
    background(0, 255, 0); // Change background color to green (indicating win)
    fill(255); // Set the fill color for the text to white
    textAlign(CENTER, CENTER); // Align the text in the center
    textSize(32); // Set the text size for the "You Win!" message
    text("You Win!", width / 2, height / 2); // Display "You Win!" at the center of the screen
    textSize(16); // Change the text size for additional instructions
    text("Press RIGHT Mouse Button to Reset", width / 2, height / 2 + 40); // Display instructions for resetting the game
    println("You Win! Press RIGHT Mouse Button to Reset"); // Print a win message to the console
  }
}
