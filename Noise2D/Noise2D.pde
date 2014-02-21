import processing.pdf.*;

float noiseXSeed = random(17);
float noiseXDelta = 0.1;

float noiseYSeed = random(1777);
float noiseYDelta = 0.2;

float maxRectDim = 8.0;

void setup() {
  size(400, 300);  
  smooth();
  rectMode(CENTER);
  
  //drawSquares();
  drawLines();
}

void drawLines() {
  clear();
  background(255);
  
  noFill();
  stroke(120, 120, 120);
   
  for (int x = 0; x < width; x+=5) {
    noiseXSeed += noiseXDelta;
    for (int y = 0; y < height; y+=5) {
      float ns = noise(noiseXSeed, noiseYSeed);      
      float angle = 2.0*PI*ns;
      float sz = ns*25.0;
            
      noiseYSeed += noiseYDelta;
      
      pushMatrix();
      translate(x, y);
      rotate(angle);
      line(0, 0, sz, 0);
      popMatrix();
    }
  }
}

void drawSquares() {
  clear();
  background(255);
  
  noFill();
  stroke(10, 20, 100);
  
  for (int x = 0; x < width; x+=5) {
    noiseXSeed += noiseXDelta;
    for (int y = 0; y < height; y+=5) {
      float dim = maxRectDim*noise(noiseXSeed, noiseYSeed);
            
    noiseYSeed += noiseYDelta;  
      pushMatrix();
      translate(x, y);
      rect(0, 0, dim, dim);
      popMatrix();
    }
  }
}

