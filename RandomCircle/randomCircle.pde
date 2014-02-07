void setup() {
  size(600, 400);
  noFill();
  strokeWeight(5);
  background(255);
  smooth();
  stroke(0);

  int radius = 60;
  float maxVariance = 17.0;

  for (int i = 0; i < 10; i++) {
    radius += 5 + 40.0*mynoise(cos(7.0*i));
    maxVariance += mynoise(sin(77*i))*2.8;
    drawRandomisedCircle(radius, maxVariance, 360, 22);
  }
}

void drawRandomisedCircle(int radius, float maxVariance, int loops, int smoothness) {
  float seed = 17*radius*maxVariance;
  float radVariance = 0.0;
  beginShape();
  for (int i = 0; i < loops; i++) {
    float rads = radians(i);

    if ((i % smoothness) == 0) {
      radVariance = radius + maxVariance*mynoise(seed);
      seed += 11;
    }

    float x = width / 2 + radVariance*cos(rads);
    float y = height / 2 + radVariance*sin(rads);
    curveVertex(x, y);
  }

  endShape();
}

float mynoise(float seed) {
  return noise(seed);
}

