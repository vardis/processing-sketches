/*
Newtonian motion can be modeled using dynamics (which take into account the forces acting upon 
 a moving object) or kinematics which is simpler and involves only the temporal and spatial properties 
 of an object. That is, given the current spatial location of an object, where is it going to be in 
 the next time step.
 
 Loup Verlet, a physicist at MIT, pioneered the computational modeling of molecular dynamics in the 1960s. He
 introduced a simple technique for modeling trajectories of motion of particles that is commonly used in com-
 puter graphics. Verlet integration, as it has come to be called, involves computing the spatial position in the next
 time step based on the object’s previous position. That is, in the simplest case where the object is moving at
 constant speed (that is, translating); the object continues to move at the same speed, in the same direction from
 its previous position. This is modeled by keeping track of an object’s current as well as previous position:
 
 Location(t+1) = Location(t) + (Location(t) - Location(t-1))
 
 That is, in order to compute the location of an object in the next time step, add the difference from the previous
 time step to the current location. This equation also requires the specification of the initial conditions Location 0
 and Location 1 .
 
 The advantage of using the Verlet integration model, is that it is possible to generate a natural spring-like constraint.
 */

class VerletBall {
  float radius;
  PVector location = new PVector();
  PVector prevLocation = new PVector();

  /** used to differentiate the location from the prevLocation in cases where we reset the position */
  PVector nudge;  

  VerletBall(float x, float y, float r) {
    location.x = x;
    location.y = y;
    radius = r;

    nudge = new PVector(random(1, 2), random(1, 2));
    prevLocation.set(location);
    prevLocation.add(nudge);
  }

  void update() {
    PVector temp = location.get();
    location.x += location.x - prevLocation.x;
    location.y += location.y - prevLocation.y;
    prevLocation.set(temp);

    bounce();
  }

  void draw() {
    noStroke();
    fill(255, 0, 0);
    ellipse(location.x, location.y, 2*radius, 2*radius);
  }

  void bounce() {
    if (location.x > (width-radius)) { // bounce against the right edge
      location.x = width-radius;
      prevLocation.x = location.x;
      prevLocation.x += nudge.x;
    }
    if (location.x < radius) { // bounce against the left edge
      location.x = radius;
      prevLocation.x = location.x;
      prevLocation.x -= nudge.x;
    }
    if (location.y > (height-radius)) { // bounce against the bottom edge
      location.y = height-radius;
      prevLocation.y = location.y;
      prevLocation.y += nudge.y;
    }
    if (location.y < radius) { // bounce against the top edge
      location.y = radius;
      prevLocation.y = location.y;
      prevLocation.y -= nudge.y;
    }
  } // bounce()
}

class Stick {
  VerletBall b1, b2;
  float length;
  float stiffness;

  Stick(VerletBall b1, VerletBall b2, float s) {
    this.b1 = b1;
    this.b2 = b2;
    this.length = b1.location.dist(b2.location);
    this.stiffness = s;
  }  

  void draw() {
    stroke(0, 0, 255);
    strokeWeight(5);
    line(b1.location.x, b1.location.y, b2.location.x, b2.location.y);
    b1.draw();
    b2.draw();
  }

  void update() {
    b1.update();
    b2.update();
    constraintMovement();
  }

  void constraintMovement() {
    PVector offset = PVector.sub(b2.location, b1.location);
    float mag = offset.mag();
    float d =  (mag - length) / mag;
    b1.location.x += offset.x * stiffness * d / 2; 
    b1.location.y += offset.y * stiffness * d / 2;

    b2.location.x -= offset.x * stiffness * d / 2; 
    b2.location.y -= offset.y * stiffness * d / 2;
  }
}


final int numBalls = 4;
final int stickLen = 40;
VerletBall[] balls = new VerletBall[numBalls];
Stick[] sticks = new Stick[numBalls - 1];

void setup() {
  size(800, 600);
  smooth();  

  for (int i = 0; i < numBalls; i++) {
    VerletBall ball = new VerletBall(width/2 + i*stickLen, height/2, 10);    
    balls[i] = ball;
  }

  for (int j = 0; j < numBalls - 1; j++) {
    Stick s = new Stick(balls[j], balls[j+1], 0.12);
    sticks[j] = s;
  }
}

void draw() {  
  fill(255);
  background(255);
  clear();
  for (Stick s : sticks) {    
    s.update();
    s.draw();
  }
}

