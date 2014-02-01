
void setup() {
 size(800, 600);
  background(255);
   smooth(); 
}

void drawCircle(int x, int y, int radius) {
  if (radius > 2) {
    stroke(0);
    noFill();
    ellipse(x, y,  radius, radius);
    drawCircle(x - radius/2, y/2, radius/2);
    drawCircle(x + radius/2, y/2, radius/2);
  }
}

void draw() {
  translate(width/2, height/2);
 drawCircle(0, 0, width/2); 
}

