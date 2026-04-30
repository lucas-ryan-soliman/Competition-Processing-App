// ---------------- FISH ----------------
class Fish {
  float x, y, speed, size;
  color c;

  Fish(float x, float y) {
    this.x = x;
    this.y = y;
    speed = random(1, 6);
    size = random(20, 40);
    c = color(random(255), random(255), random(255));
  }

  void update() {
    x += speed;
    if (x > width + 50) {
      x = -50;
      y = random(100, sandY - 50);
    }
  }

  void display() {
    fill(c);
    ellipse(x, y, size * 2, size);

    triangle(x - size, y,
      x - size * 2, y - size/2,
      x - size * 2, y + size/2);

    fill(0);
    ellipse(x + size/2, y - 3, 4, 4);
  }
}

// ---------------- JELLYFISH ----------------
class Jelly {
  float x, y, speed, offset;

  Jelly(float x, float y) {
    this.x = x;
    this.y = y;
    speed = random(0.5, 1.5);
    offset = random(100);
  }

  void update() {
    y += speed;
    x += sin(frameCount * 0.05 + offset) * 0.5;

    if (y > sandY - 20) {
      y = -40;
      x = random(width);
    }
  }

  void display() {
    fill(200, 100, 255, 180);
    ellipse(x, y, 40, 30);

    for (int i = -2; i <= 2; i++) {
      float tx = x + i * 6;
      float wave = sin(frameCount * 0.1 + i) * 5;
      line(tx, y + 15, tx + wave, y + 40);
    }
  }
}

// ---------------- CRAB ---------------- //
class Crab {
  float x, y;
  float dir = 1;

  Crab(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    x += dir * 1.5;
    if (x > width - 40 || x < 40) {
      dir *= -1;
    }
  }

  void display() {
    fill(255, 80, 80);
    ellipse(x, y, 50, 30);

    fill(0);
    ellipse(x - 10, y - 15, 5, 5);
    ellipse(x + 10, y - 15, 5, 5);

    stroke(0);
    strokeWeight(2);

    for (int i = -2; i <= 2; i++) {
      line(x + i * 12, y + 15,
        x + i * 18, y + 28);
    }

    line(x - 25, y + 5, x - 40, y - 5);
    line(x + 25, y + 5, x + 40, y - 5);

    noStroke();
  }
}

// ---------------- BUBBLES ---------------- //
class Bubble {
  float x, y;
  float speed;
  float offset;
  float size;

  Bubble(float x, float y) {
    this.x = x;
    this.y = y;
    speed = random(1, 3);
    offset = random(100);
    size = random(5, 15);
  }

  void update() {
    y -= speed;
    x += sin(frameCount * 0.05 + offset) * 1.5;

    if (y < -20) {
      y = height + 20;
      x = random(width);
    }
  }

  void display() {
    stroke(255, 150);
    noFill();
    ellipse(x, y, size, size);
  }
}

// ---------------- SCUBA DIVER ---------------- //
class ScubaDiver {
  float x, y;
  float speed;

  ScubaDiver(float x, float y) {
    this.x = x;
    this.y = y;
    speed = 2;
  }

  void update() {
    x += speed;

    if (x > width + 100) {
      x = -100;
      y = random(150, sandY - 150);
    }
  }

  void display() {
    pushMatrix();
    translate(x, y);
    rotate(radians(5));

    fill(120);
    rect(-15, -20, 30, 12, 5);

    stroke(0);
    line(-3, -5, -3, 10);

    noStroke();
    fill(20);
    ellipse(0, 0, 30, 14);

    fill(255, 220, 180);
    ellipse(18, -2, 14, 14);

    fill(80, 180, 255, 200);
    ellipse(20, -2, 10, 10);

    stroke(0);
    line(24, -8, 24, -18);

    strokeWeight(2);
    line(5, 0, 12, 8);
    line(-2, 0, -8, 8);

    float kick = sin(frameCount * 0.2) * 6;

    line(-5, 5, -10, 15 + kick);
    line(5, 5, 10, 15 - kick);

    strokeWeight(3);
    line(-10, 15 + kick, -16, 20 + kick);
    line(10, 15 - kick, 16, 20 - kick);

    noFill();
    stroke(255, 180);
    for (int i = 0; i < 4; i++) {
      float bx = 25 + i * 6;
      float by = -5 - i * 10 + sin(frameCount * 0.1 + i) * 3;
      ellipse(bx, by, 4 + i, 4 + i);
    }

    popMatrix();
  }
}
