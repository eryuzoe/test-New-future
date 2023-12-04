int centerX, centerY; // 圆心位置
int outerRadius = 400; // 外圆半径
int innerRadius = 300; // 内圆半径
int menuRadius = 200; // menu圆半径
int switchRadius = 100; // switch圆半径
int buttonRadius = 50; // 按钮半径
float angle; // 当前角度
float lastAngle; // 上一个角度位置
float maxAngle; // 按钮扫过的最远角度


void setup() {
  fullScreen(); // 设置窗口大小
  centerX = width / 2;
  centerY = height / 2;
  float initialAngle = 150 * (PI / 180); // 七点钟方向的角度，转换为弧度
  angle = initialAngle; // 设置初始角度为七点钟方向
  lastAngle = angle; // 设置初始的上一个角度
}

void draw() {
  updateBackgroundColor(); // 更新背景颜色
  drawRings();
  drawButton();
  drawWhiteRectangle(centerX, centerY-140); // 绘制长方形
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
  int white = color(255); // 白色
  int green = color(98,167,148); // 
  int pink = color(244,152,184); // 
  int segments = 360; // 渐变的段数

  noFill();
  for (int i = 0; i < segments; i++) {
    float angleStart = radians(i * (360.0 / segments));
    float angleEnd = radians((i + 1) * (360.0 / segments));
    float inter = float(i) / segments;
    int c;

    if (inter < 0.25) { // 
      c = lerpColor(white, green, inter * 4);
    } else if (inter < 0.5) { // 
      c = lerpColor(green, white, (inter - 0.25) * 4);
    } else if (inter < 0.75) { // 
      c = lerpColor(white, pink, (inter - 0.5) * 4);
    } else { // 
      c = lerpColor(pink, white, (inter - 0.75) * 4);
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

  fill(132,131,136); // 设置按钮颜色为灰色
  ellipse(x, y, buttonRadius * 2, buttonRadius * 2); // 绘制按钮
}

void mousePressed() {
  // 计算鼠标和按钮中心的距离
}

void mouseDragged() {
  float dx = mouseX - centerX;
  float dy = mouseY - centerY;
  float currentAngle = atan2(dy, dx);
  
  if (currentAngle < 150 * (PI / 180)) {
    currentAngle += TWO_PI; // 确保角度是正值
  }

  // 检查是否反向旋转
  if (currentAngle < lastAngle) {
    maxAngle = currentAngle; // 减少蓝色轨迹覆盖范围
  } else if (currentAngle > maxAngle) {
    maxAngle = currentAngle; // 增加蓝色轨迹覆盖范围
  }

  lastAngle = currentAngle; // 更新上一个角度
  angle = currentAngle; // 更新当前角度
}

void updateBackgroundColor() {
  float inter = (angle - 150 * (PI / 180)) / (2 * PI);
  inter = (inter + 1) % 1; // 确保inter在0到1之间

  // 确保颜色插值正确对应按钮所在的位置
  inter = 1 - inter; // 反转插值方向

  int white = color(255); // 白色
  int green = color(98,167,148); // 
  int pink = color(244,152,184); //
  int bgColor;

  if (inter < 0.25) {
    bgColor = lerpColor(white, green, inter * 4);
  } else if (inter < 0.5) {
    bgColor = lerpColor(green, white, (inter - 0.25) * 4);
  } else if (inter < 0.75) {
    bgColor = lerpColor(white, pink, (inter - 0.5) * 4);
  } else {
    bgColor = lerpColor(pink, white, (inter - 0.75) * 4);
  }

  background(bgColor); // 设置背景颜色
}


 void mouseReleased() {
  // [鼠标释放事件处理代码]
}
