int centerX, centerY; // 圆心位置
int outerRadius = 400; // 外圆半径
int innerRadius = 300; // 内圆半径
int menuRadius = 200; // menu圆半径
int switchRadius = 100; // switch圆半径
int buttonRadius = 50; // 按钮半径
float angle; // 当前角度
int percentage = 0; // 按钮位置对应的整数百分比
float startAngle = -PI / 2; // 以12点钟方向为起始点
float accumulatedAngle = 0; // 从起始点开始累积的角度
float lastDragAngle = startAngle; // 记录上一次拖动时按钮的角度


void setup() {
  fullScreen();
  centerX = width / 2;
  centerY = height / 2;
  angle = -PI / 2; // 设置初始角度为12点钟方向
  lastDragAngle = angle; // 初始化上一次拖动角度
}

void draw() {
  background(255);
  drawOuterCircleGradient(centerX, centerY, outerRadius);
  drawInnerCircleLinearGradient(centerX, centerY, innerRadius);
  drawButton();
  drawWhiteRectangle(centerX, centerY - 140);
  drawText(centerX, centerY - 150, percentage);
}

void drawRings() {
  drawOuterCircleGradient(centerX, centerY, outerRadius); // 绘制外圆的渐变
  drawInnerCircleLinearGradient(centerX, centerY, innerRadius);
  
  fill(196,199,204); // 设置menu圆颜色
  noStroke();
  ellipse(centerX, centerY, menuRadius * 2, menuRadius * 2); // 绘制menu圆
  
  fill(219,220,221); // 设置switch圆颜色
  noStroke();
  ellipse(centerX, centerY, switchRadius * 2, switchRadius * 2); // 绘制switch圆
  
}

void drawOuterCircleGradient(int cx, int cy, int radius) {
  int orange = color(255, 165, 0,200);
  int pink = color(244,152,184,200);
  int purple = color(128, 0, 128,200);
  int blue = color(135,176,230,200);
  int cyan = color(98,152,186,200);
  int green = color(98,167,148,200);
  int segments = 360; // 渐变的段数

  noFill();
  for (int i = 0; i < segments; i++) {
    float angleStart = radians(i * (360.0 / segments));
    float angleEnd = radians((i + 1) * (360.0 / segments));
    float inter = float(i) / segments;
    int c;

    if (inter < 0.2) {
      c = lerpColor(orange, pink, inter / 0.2);
    } else if (inter < 0.4) {
      c = lerpColor(pink, purple, (inter - 0.2) / 0.2);
    } else if (inter < 0.6) {
      c = lerpColor(purple, blue, (inter - 0.4) / 0.2);
    } else if (inter < 0.8) {
      c = lerpColor(blue, cyan, (inter - 0.6) / 0.2);
    } else {
      c = lerpColor(cyan, green, (inter - 0.8) / 0.2);
    }

    fill(c);
    arc(cx, cy, radius * 2, radius * 2, angleStart, angleEnd);
  }
}


void drawInnerCircleLinearGradient(int cx, int cy, int radius) {
  noFill();
  for (int y = cy - radius; y <= cy + radius; y++) {
    float inter = map(y, cy - radius, cy + radius, 0, 1);
    int c;
    if (y < cy) { // 上半部分：从橙色渐变到白色
      c = lerpColor(color(255, 185, 123), color(255), map(y, cy - radius, cy, 0, 1));
    } else { // 下半部分：从白色渐变到蓝色
      c = lerpColor(color(255), color(135, 176, 230), map(y, cy, cy + radius, 0, 1));
    }
    stroke(c);

    // 计算该y坐标下，线条的起始和结束x坐标
    float dx = sqrt(sq(radius) - sq(cy - y));
    line(cx - dx, y, cx + dx, y);
  }
}


void drawWhiteRectangle(int x, int y) {
  noStroke(); // 无边框
  fill(255); // 白色填充
  rectMode(CENTER); // 设置绘制模式为中心点模式
  rect(x, y, 100,40); // 绘制长方形
}

void drawButton() {
  int x = centerX + int(cos(angle) * (outerRadius + innerRadius) / 2);
  int y = centerY + int(sin(angle) * (outerRadius + innerRadius) / 2);
  fill(132, 131, 136);
  ellipse(x, y, buttonRadius * 2, buttonRadius * 2);
}

void drawText(int x, int y, float pct) {
  fill(0);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Are you happy with your sleep?", x, y - 20);
  textSize(20);
  text(nf(pct, 0, 2) + "%", x, y);
}

void mousePressed() {
  // 计算鼠标和按钮中心的距离
}

void mouseDragged() {
  float dx = mouseX - centerX;
  float dy = mouseY - centerY;
  float currentAngle = atan2(dy, dx);
  
  if (currentAngle < 0) {
    currentAngle += TWO_PI; // 保证角度为正值
  }
  
  angle = currentAngle; // 更新按钮位置
  updatePercentage();
}

void updatePercentage() {
  float normalizedAngle = (angle - startAngle + TWO_PI) % TWO_PI; // 标准化角度
  percentage = int(normalizedAngle / TWO_PI * 100); // 根据角度计算百分比
}



 void mouseReleased() {
  // [鼠标释放事件处理代码]
}
