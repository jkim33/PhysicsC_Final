//Jason Kim & Dylan Kim
//AP PHYSICS C - FINAL PROJECT

Rod rod;
Rod display;
Ball ball;
float rot;
float w;
boolean looking;
boolean nothing;
boolean launching;
boolean moving;
boolean contact;
boolean completed;

float rod_len, rod_mass, ball_x, left, right, ball_mass, arc_start, friction;

void setup() {
  size(1000, 1000);
  background(0);
  stroke(255);
  strokeWeight(3);
  rod_len = 250;
  rod_mass = 3;
  ball_x = 300;
  left = 0;
  right = 600;
  ball_mass = 1;
  arc_start = 0;
  rod = new Rod(300,300,rod_len,rod_mass);
  ball = new Ball(ball_x,700,left,right,ball_mass);
  rot = 0;
  nothing = true;
  launching = false;
  moving = false;
  contact = false;
  completed = false;
  w = 0;
  friction = 0.15;
}

void draw() {
  clear();
  if (nothing) {
    ball.left_right(mouseX);
  }
  fill(120);
  strokeWeight(0);
  arc(rod.arx, rod.ary, 580, 580, arc_start, arc_start+(2*PI/5.0));
  fill(255);
  strokeWeight(3);
  if (launching) {
    if (mouseY > ball.y) {
      if (mouseX < ball.x) {
        line(ball.x, ball.y, ball.x + (ball.x - mouseX), ball.y - (mouseY - ball.y));
      }
      else {
        line(ball.x, ball.y, ball.x - (mouseX - ball.x), ball.y - (mouseY - ball.y));
      }
    }
    else {
      if (mouseX < ball.x) {
        line(ball.x, ball.y, ball.x + (ball.x - mouseX), ball.y + (ball.y - mouseY));
      }
      else {
        line(ball.x, ball.y, ball.x - (mouseX - ball.x), ball.y + (ball.y - mouseY));
      }
    }
  }
  if (moving) {
   if(rod.ball_hit(ball)) {
     w = calculate_w(rod.mass, ball.mass, ball.vy, rod.len, ball.x - rod.arx);
     ball.destroy();
     moving = false;
     contact = true;
   }
  }
  ball.move();
  if (!looking) {
    strokeWeight(0);
    ball.display();
    strokeWeight(3);
  }
  rect(600,0,400,1200);
  fill(255);
  stats();
  rot += w/60.0;
  rod.display(rot);
  if (w < 0) {
    w += (friction * 9.81 / ((rod.len/50.0) / 2.0)) / 60.0;
  }
  else {
    w = 0;
  }
  if (!completed && w == 0 && contact) {
    completed = win();
  }
}

boolean win() {
  float value = 2*PI - abs(rot%(2*PI)) ;
  if (value > arc_start && value < arc_start + (2.0*PI)/5.0) {
    return true;
  }
  return false;
}

void stats() {
  textSize(34);
  fill(0);
  if (launching) {
    text("Ball's Velocity: \n   " + 5 * dist(ball.x, ball.y, mouseX, mouseY)/50.0 + " m/s", 607,60);
  }
  else {
    text("Ball's Velocity: \n   " + dist(0, 0, ball.vx, ball.vy)/50.0 + " m/s", 607,60);
  }
  text("Angular Velocity: \n   " + abs(w) + " rad/s", 607, 165);
  text("Rod Mass: \n   " + rod.mass + " kg", 607, 270);
  text("Ball Mass: \n   " + ball.mass + " kg", 607, 375);
  text("Rod Length: \n   " + rod.len/50.0 + " m", 607, 480);
  text("Coefficient of Fricition: \n   " + friction, 607, 585);
  if (nothing || launching) {
    text("Shoot the ball!", 607, 820);
  }
  if (moving) {
    text("Will it hit?", 607, 820);  
  }
  if (contact && w != 0) {
     text("The rod's spinning!", 607, 820);
  }
  if (contact && w == 0) {
    if (win()) {
      text("Nice! New Level!", 607, 820);
    }
    else {
      text("Try again!", 607, 820);
    }
  }
  rect(607, 850, 186, 60);
  if (completed) {
    rect(807, 850, 186, 60);
  }
  fill(255);
  text("Retry",655,890);
  if (completed) {
    text("New", 865, 890);
  }
}

float calculate_w(float rod_mass, float ball_mass, float velocity, float rod_length, float offset){
  float initial = ball_mass * offset * velocity;
  float finalish = (ball_mass * offset * offset) + ((rod_mass * rod_length * rod_length)/3.0);
  return initial/finalish;
}

void retry() {
  rod = new Rod(300,300,rod_len,rod_mass);
  ball = new Ball(ball_x,700,left,right,ball_mass);
  rot = 0;
  nothing = true;
  launching = false;
  moving = false;
  contact = false;
  w = 0;
}

void new_level() {
  rod_len = random(225, 275);
  rod_mass = random(2.5, 3.5);
  float len = random(200, 350);
  left = random(0, 600.0-len);
  right = left + len;
  ball_x = (right+left)/2.0;
  ball_mass = random(0.75, 1.25);
  friction = random(0.1, 0.2);
  arc_start = random(0,2*PI*.8);
  completed = false;
}

void mousePressed() {
  if (nothing && ball.withinBall(mouseX, mouseY)) {
    nothing = false;
    launching = true;
  }
}

void mouseReleased() {
  if (launching) {
    launching = false;
    moving = true;
    calculate_v();
  }
}

void mouseClicked() {
  if (607 < mouseX && mouseX < 607+186 && 850 < mouseY && mouseY < 850+60) {
    retry();
  }
  if (807 < mouseX && mouseX < 807+186 && 850 < mouseY && mouseY < 850+60 && completed) {
    new_level();
    retry();
  }
}

void calculate_v() {
  if (mouseY > ball.y) {
    if (mouseX < ball.x) {
      ball.vx = abs(ball.x-mouseX) * 5;
      ball.vy = -abs(ball.y-mouseY) * 5;
    }
    else {
      ball.vx = -abs(ball.x-mouseX) * 5;
      ball.vy = -abs(ball.y-mouseY) * 5;
    }
  }
  else {
    if (mouseX < ball.x) {
      ball.vx = abs(ball.x-mouseX) * 5;
      ball.vy = abs(ball.y-mouseY) * 5;
    }
    else {
      ball.vx = -abs(ball.x-mouseX) * 5;
      ball.vy = abs(ball.y-mouseY) * 5;
    }
  }
}

public class Rod {
  
  float arx;
  float ary;
  float len;
  float ballx;
  float bally;
  float ballr;
  float mass;
  final float half_height = 20;
  
  public Rod(float x, float y, float l, float m) {
    arx = x;
    ary = y;
    len = l;
    mass = m;
  }
  
  public void display(float rot) {
    translate(arx, ary);
    rotate(rot);
    ellipse(0,0,40,40);
    rect(0,0,len,half_height);
    rect(0,0,len,-half_height);
    ellipse(0,0,2*half_height,2*half_height);
    ellipse(ballx, bally, ballr*2, ballr*2);
    fill(0);
    ellipse(0,0,10,10);
    rect(len-20,-3,10,6);
    fill(255);
  }
  
  public boolean ball_hit(Ball b) {
    if (ary + half_height >= b.y-b.rad && ary - half_height <= b.y-b.rad) {
      if (arx <= b.x && b.x <= arx+len) {
        ballx = b.x-arx;
        bally = b.rad + half_height;
        ballr = b.rad;
        return true;
      }
    }
    return false;
  }
}

public class Ball {
  float x;
  float y;
  float consty;
  float left;
  float right;
  float vx;
  float vy;
  float mass;
  final float rad = 20;
  
  public Ball (float xcor, float ycor, float l, float r, float m) {
    x = xcor;
    y = ycor;
    consty = ycor;
    left = l;
    right = r;
    mass = m;
  }
  
  public boolean withinBall(float mx, float my) {
    if (dist(mx,my,x,y) > rad) {
      return false;
    }
    return true;
  }
  
  public void left_right(float xcor) {
    if (left <= xcor-rad && xcor+rad <= right) {
      x = xcor;
    }
  }
  
  public void move() {
    x += vx/60.0;
    y += vy/60.0;
  }
  
  public void display() {
    fill(75);
    rect(left, consty, right-left, rad);
    rect(left, consty, right-left, -rad);
    fill(255);
    ellipse(x,y,rad*2,rad*2);
  }
  
  public void destroy() {
    x = -1000;
    y = -1000;
    vx = 0;
    vy = 0;
  }
  
}
