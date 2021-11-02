import 'dart:math';

class SnakePlayer{
  int gridCount; // number of cells in the grid

  int x = 1;
  int y = 0;
  int xDir = 1;
  int yDir = 0;
  int length = 1;
  List<Position> tail = [Position(x: 0, y: 0)];

  late Position snakeFood;

  Function gameOver;
  Function winGame;

  SnakePlayer({required this.gridCount, required this.gameOver, required this.winGame}){
    var rand = Random();
    snakeFood = Position(x: rand.nextInt(gridCount), y: rand.nextInt(gridCount));
  }

  void setDirection(x, y){
    // not allow to move backward
    if(this.xDir != 0 && x != 0 || this.yDir != 0 && y != 0)
      return;

    xDir = x;
    yDir = y;
  }

  void move(){
    this.tail.insert(0, Position(x: this.x, y: this.y));

    this.x += this.xDir;
    this.y += this.yDir;

    _checkEdges(); // if snake head hit grid edge
    if(this.x == snakeFood.x && this.y == snakeFood.y)
      eat();

    this.tail.removeLast();

    _checkCollide(); // if snake head hit its own tail
  }

  void _checkEdges(){
    if(this.x >= gridCount) this.x = 0;
    else if(this.x < 0) this.x = gridCount - 1;
    else if(this.y >= gridCount) this.y = 0;
    else if(this.y < 0) this.y = gridCount - 1;
  }

  void _checkCollide(){
    if(this.tail.any((pos) => this.x == pos.x && this.y == pos.y))
      gameOver();
  }

  void eat(){
    this.length++;
    this.tail.add(this.tail.last);

    // if snake occupied whole grid
    if(this.length == gridCount * gridCount) {
      winGame();
    }
    else{
      //next food
      var rand = Random();
      snakeFood = Position(x: rand.nextInt(gridCount), y: rand.nextInt(gridCount));
    }

  }
}

class Position{
  int x;
  int y;
  Position({required this.x, required this.y});
}

