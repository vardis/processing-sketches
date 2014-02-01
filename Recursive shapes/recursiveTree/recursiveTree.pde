void setup() {
  size(800, 600);
  background(255);
  stroke(0);
  noFill();
}

void drawTree(float x, float y, float len, float angle) {
  if (len > 2) {
    float x2 = x + cos(radians(angle))*len;
    float y2 = y - sin(radians(angle))*len;

    line(x, y, x2, y2);  

    drawTree(x2, y2, len*0.7, angle + 55);
    drawTree(x2, y2, len*0.4, angle - 5);
  }
}

void drawTreeWithTransforms(float len, float angle) {
  if (len >= 2) {
    rotate(radians(angle));
    line(0, 0, len, 0);
    
    // move to next point
    translate(len, 0);
    pushMatrix();
    drawTreeWithTransforms(len*0.77, 55);
    popMatrix();
    
    pushMatrix();
    drawTreeWithTransforms(len*0.66, -25);
    popMatrix();
  }
}

void draw() {
  translate(width/2, height);
  //drawTree(width/2, height, 175, 80);
  drawTreeWithTransforms(175, -100);
}

