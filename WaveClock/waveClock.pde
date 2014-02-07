float angleNoise, radNoise, cxNoise, cyNoise;
float strokeCol = 254;
int strokeDelta = -1;
float angle = 0.0;

void setup() {
  size(600, 400);
  noFill();
  strokeWeight(5);
  background(255);
  smooth();
  stroke(0);
  frameRate(30);
  
  angleNoise = random(10);
  radNoise = random(10);
  cxNoise = random(10);
  cyNoise = random(10);
}

void draw() {
  angleNoise += 0.005;
  angle += noise(angleNoise)*6 - 3;
  angle = angle % 360.0;
 
 radNoise += 0.005;
float radius = noise(radNoise)*550 + 1;

  cxNoise += 0.01;
  cyNoise += 0.01;
  float cx = width/2 + noise(cxNoise)*100 - 50;
  float cy = height/2 + noise(cyNoise)*100 - 50;
  
  float rads = radians(angle);
  float c = cos(rads);
 float s = sin(rads); 
  float x1 = cx + radius*c;
  float y1 = cy + radius*s;
  
  float x2 = cx - radius*c;
  float y2 = cy - radius*s;

  strokeCol += strokeDelta;
  if (strokeCol > 254) strokeDelta = -1;
  if (strokeCol < 0) strokeDelta = 1;
  
  stroke(strokeCol, 60);
  strokeWeight(1);
  line(x1, y1, x2, y2);
}

