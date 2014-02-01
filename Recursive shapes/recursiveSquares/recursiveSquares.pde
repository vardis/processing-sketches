void setup() {
  size(800, 600);
  background(255);
  smooth(); 
  rectMode(CENTER);
}

void drawBox(int x, int y, int size) {
  stroke(0);
  noFill();
  strokeWeight(0.02*size);
  stroke(size);
  rect(x, y, size, size);
  if (size > 20) {    
    drawBox(x - size/2, y - size/2, size/2);
     drawBox(x + size/2, y-size/2, size/2);
     drawBox(x + size/2, y + size/2, size/2);
    drawBox(x - size/2, y + size / 2, size/2);
  }
}

void draw() {

  drawBox(width/2, height/2, width/2);
}

