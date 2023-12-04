int centerX, centerY; // 圆心位置
int outerRadius = 400; // 外圆半径
int innerRadius = 300; // 内圆半径
int menuRadius = 200; // menu圆半径
int switchRadius = 100; // switch圆半径
int buttonRadius = 50; // 按钮半径
float angle; // 当前角度
float startAngle = 150 * (PI / 180); // 扫过区域的起始角度
float endAngle = 150 * (PI / 180); // 扫过区域的结束角度
boolean isDragging = false; // 标记是否正在拖动按钮
float sectorAngle; // 扇形的角度
int counter = 1; // 初始化计数器
float lastButtonAngle = 0; // 记录上一次按钮的角度
float totalRotation = 0; // 跟踪按钮的总旋转角度
float maxRotationAngle = 112 * (PI / 180); // 最大旋转角度为119度
float anglePerSection = 17 * (PI / 180); // 每个区间的角度为17度
float initialAngle = 150 * (PI / 180); // 初始角度



void setup() {
  fullScreen(); // 设置窗口大小
  centerX = width / 2;
  centerY = height / 2;
  float initialAngle = 150 * (PI / 180); // 七点钟方向的角度，转换为弧度
  angle = initialAngle; // 设置初始角度为七点钟方向
  sectorAngle = random(100 * (PI / 180), 150 * (PI / 180)); // 初始化扇形角度为100至150度
}

void draw() {
  drawGradientBackground(); // 绘制渐变背景
  drawRings();
  drawButton();
  drawWhiteRectangle(centerX, centerY-140);
  drawWhiteRectangleWithCounter(centerX, centerY-140); // 绘制带有计数器的长方形
}

// 自定义函数绘制橙色到白色再到蓝色的渐变背景
void drawGradientBackground() {
  for (int i = 0; i < height; i++) {
    float inter;
    int c;

    if (i < height / 2) {
      // 从橙色渐变到白色
      inter = map(i, 0, height / 2, 0, 1);
      c = lerpColor(color(255, 185, 123), color(255), inter);
    } else {
      // 从白色渐变到蓝色
      inter = map(i, height / 2, height, 0, 1);
      c = lerpColor(color(255), color(135, 176, 230), inter);
    }

    stroke(c);
    line(0, i, width, i);
  }
}

void drawRings() {
  fill(247,154,84); // 设置外圆颜色
  noStroke();
  ellipse(centerX, centerY, outerRadius * 2, outerRadius * 2); // 绘制外圆
  drawRandomConcentricSector();
  drawInnerCircleLinearGradient(centerX, centerY, innerRadius);
  
  fill(196,199,204); // 设置menu圆颜色
  noStroke();
  ellipse(centerX, centerY, menuRadius * 2, menuRadius * 2); // 绘制menu圆
  
  fill(219,220,221); // 设置switch圆颜色
  noStroke();
  ellipse(centerX, centerY, switchRadius * 2, switchRadius * 2); // 绘制switch圆
  
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

void drawConcentricSector() {
  fill(46, 46, 142); // 设置扇形的颜色（例如红色）
  noStroke(); // 设置扇形边框的颜色
  strokeWeight(2); // 设置边框粗细
  arc(centerX, centerY, outerRadius * 2, outerRadius * 2, 150 * (PI / 180), 300 * (PI / 180), PIE);
}

void drawButton() {
  // 计算按钮在内圆与menu圆之间的位置
  float midRadius = (innerRadius + menuRadius) / 2;
  int x = centerX + int(cos(angle) * midRadius);
  int y = centerY + int(sin(angle) * midRadius);
  fill(132,131,136); // 设置按钮颜色为灰色
  ellipse(x, y, buttonRadius * 2, buttonRadius * 2); // 绘制按钮
}

void drawWhiteRectangleWithCounter(int x, int y) {
  drawWhiteRectangle(x, y); // 绘制长方形
  fill(0); // 设置文字颜色为黑色
  textAlign(CENTER, CENTER);
  text(counter, x, y); // 在长方形中显示计数器
}

void drawWhiteRectangle(int x, int y) {
  noStroke(); // 无边框
  fill(255); // 白色填充
  rectMode(CENTER); // 设置绘制模式为中心点模式
  rect(x, y, 100,40); // 绘制长方形
}

void drawRandomConcentricSector() {
  float centerLine = 225 * (PI / 180); // 扇形的中心线位置
  fill(46, 46, 142); // 随机颜色
  arc(centerX, centerY, outerRadius * 2, outerRadius * 2, centerLine - sectorAngle / 2, centerLine + sectorAngle / 2, PIE);
}

void mousePressed() {
  // 计算鼠标和按钮中心的距离
  isDragging = true;
}

void mouseDragged() {
  float dx = mouseX - centerX;
  float dy = mouseY - centerY;
  float currentAngle = atan2(dy, dx);
  if (currentAngle < 0) {
    currentAngle += TWO_PI; // 确保角度是正值
  }

  // 计算从初始位置开始的逆时针旋转角度
  float rotationAngle = initialAngle - currentAngle;
  if (rotationAngle < 0) {
    rotationAngle += TWO_PI;
  }

  // 限制旋转角度
  if (rotationAngle > maxRotationAngle) {
    rotationAngle = maxRotationAngle;
  }

  // 更新按钮位置
  angle = initialAngle - rotationAngle;

  // 更新计数器
  updateCounter(rotationAngle);
}

void updateCounter(float rotationAngle) {
  // 计算按钮所在的区间
  int section = int(rotationAngle / anglePerSection) + 1;
  if (section != counter) { // 当区间发生变化时
    counter = section;
    // 重新设置扇形角度
    sectorAngle = random(100 * (PI / 180), 150 * (PI / 180)); 
  }
}

void mouseReleased() {
  }
