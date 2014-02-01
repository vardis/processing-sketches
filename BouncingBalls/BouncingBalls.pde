class Box {
  PVector pos;
  int width;
  int height;
  
  Box(int x, int y, int w, int h) {
    this.pos = new PVector(x, y);
    width = w;
    height = h;
  }
  
  PVector getPos() { return pos.get(); }
  int getWidth() { return width; }
  int getHeight() { return height; }
  
  void draw() {
    stroke(0);
    fill(255);
    rect(pos.x, pos.y, width, height);
  }
}

class Ball {
  PVector pos;
  PVector oldPos;
  PVector velocity;
  Box container;
  float radius;
  
  Ball(PVector p, Box cont, float radius) {
    this.pos = p;
    this.container = cont;
    this.radius = radius;
    this.velocity = new PVector();
  }
  
  void setVelocity(PVector v) {
    this.velocity.set(v);
  }
  
  PVector getPos() { return pos.get(); }
  PVector getOldPos() { return oldPos.get(); }
  float getRadius() { return radius; }
  
  void update() {
    pos.add(velocity);
    bounce(); 
  }
  
  void bounce() {
    PVector contPos = container.getPos();
    float maxContX = contPos.x + container.getWidth();
    float minContX = contPos.x;
    float maxContY = contPos.y + container.getHeight();
    float minContY = contPos.y;
    
    boolean bouncedLeft = (pos.x + radius) > maxContX;
    boolean bouncedRight = (pos.x - radius) < minContX;  
    if (bouncedLeft || bouncedRight) {
      if (bouncedLeft) {
        pos.x = maxContX - radius;
      } else {
        pos.x = minContX + radius;
      }
      velocity.x = -velocity.x;
    } 
    
    boolean bouncedTop = (pos.y - radius) < minContY;
    boolean bouncedBottom = (pos.y + radius) > maxContY; 
    if (bouncedTop || bouncedBottom) {
      if (bouncedTop) {
        pos.y = minContY + radius;
      } else {
        pos.y = maxContY - radius;
      }
     velocity.y = -velocity.y;
    }
  }
  
  void draw() {    
    fill(255, 0, 0);
    stroke(0);
    ellipse(pos.x, pos.y, 2*radius, 2*radius);
  }
}

class BallsTile {
  ArrayList<Ball> balls = new ArrayList<Ball>();
  Box box;

  BallsTile(Box box, int numBalls) {
    this.box = box;
    for (int i = 0; i < numBalls; i++) {
      float radius = 5 + random(0.1*min(box.getWidth(), box.getHeight()));
      Ball b = new Ball(new PVector(random(box.getWidth() - radius), random(box.getHeight() - radius)), box, radius);
      b.setVelocity(new PVector(random(2) - 1, random(2) - 1));
      balls.add(b);
    }
  } 
  
  void update() {
    for (Ball b : balls) b.update();
  }
  
  void draw() {
    box.draw();
    for (Ball b : balls) b.draw();
  }
}

BallsTile tile;

ArrayList<BallsTile> tiles = new ArrayList<BallsTile>();

void setup() {
  size(512,512);
  smooth();
  noStroke();
  
  int w = 100, h = 100, off = 5;
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      Box box = new Box(i*w + off, j*h + off, w, h);
      tiles.add(new BallsTile(box, 1 + (int)random(10)));
    }
  }  
}

void draw() {
  clear();
  for (BallsTile tile : tiles) {
    tile.update();
    tile.draw();
  }
}



  
