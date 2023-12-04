SleepCircle sleepCircle;
WakeCircle wakeCircle;
boolean inSleepCircle = false;
boolean inWakeCircle = false;
int centerX, centerY; // 圆心位置
int outerRadius = 400; // 外圆半径
int innerRadius = 300; // 内圆半径
int menuRadius = 200; // menu圆半径
int switchRadius = 100; // switch圆半径
int buttonRadius = 50; // 按钮半径
float angle; // 当前角度
float startAngle = 150 * (PI / 180); // 扫过区域的起始角度
float endAngle = 150 * (PI / 180); // 扫过区域的结束角度
int doubleClickThreshold = 300; // 双击的时间阈值，单位为毫秒
int lastClickTime = 0; // 上一次点击的时间


void setup() {
  fullScreen(); // 设置窗口大小
  sleepCircle = new SleepCircle(this);
  wakeCircle = new WakeCircle(this);
  centerX = width / 2;
  centerY = height / 2;
  float initialAngle = 150 * (PI / 180); // 七点钟方向的角度，转换为弧度
  angle = initialAngle; // 设置初始角度为七点钟方向
  endAngle = angle; // 设置初始的上一个角度
}

void draw() {
  drawGradientBackground(); // 绘制渐变背景
  drawRings();
  drawButton();
  drawWhiteRectangle(centerX, centerY-140); // 绘制长方形
  if (inSleepCircle) {
    sleepCircle.display();
  } else if (inWakeCircle) {
    wakeCircle.display();
  } else {
    // 默认显示内容或者主界面
  }
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
  
  updateSweepArea();
  fill(46, 46, 142); // 设置扫过区域的颜色为蓝色
 // if (endAngle > startAngle) {
  //  arc(centerX, centerY, outerRadius * 2, outerRadius * 2, startAngle, endAngle, PIE);
 // } else {
  //  arc(centerX, centerY, outerRadius * 2, outerRadius * 2, endAngle, startAngle, PIE);
 // }

  drawConcentricSector(); // 绘制同心扇形
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
    int currentTime = millis(); // 获取当前时间
    if (currentTime - lastClickTime < doubleClickThreshold) {
        // 双击发生，返回主程序
        inSleepCircle = false;
        inWakeCircle = false;
    } else {
 int centerX = width / 2;
  int centerY = height / 2;
  int radius = 400; // 假设外圆和扇形半径相同

  // 计算鼠标位置和圆心之间的距离
  float distance = dist(mouseX, mouseY, centerX, centerY);

  // 检查鼠标点击是否在圆内
  if (distance <= radius) {
    // 计算鼠标点击位置和圆心之间的角度
    float angle = atan2(mouseY - centerY, mouseX - centerX);

    // 转换角度范围到 0 至 TWO_PI
    if (angle < 0) {
      angle += TWO_PI;
    }

    // 定义扇形的开始和结束角度
    float startAngle = 150 * (PI / 180); // 扇形开始角度
    float endAngle = 300 * (PI / 180); // 扇形结束角度

    // 检查点击是否在扇形区域内
    if (angle >= startAngle && angle <= endAngle) {
    inSleepCircle = true;
    inWakeCircle = false;
    } else {
    inSleepCircle =false;
    inWakeCircle = true;
    }
  }
    }
    lastClickTime = currentTime; // 更新最后点击时间
}


void mouseDragged() {
 float dx = mouseX - centerX;
  float dy = mouseY - centerY;
  float currentAngle = atan2(dy, dx);
  
  if (currentAngle < 0) {
    currentAngle += TWO_PI; // 确保角度是正值
  }

  angle = currentAngle; // 更新当前角度
  endAngle = angle; // 更新扫过区域的结束角度
}

void updateSweepArea() {
  // 检查是否需要重置扫过区域的起始角度
  if (abs(endAngle - startAngle) > TWO_PI) {
    startAngle = endAngle;
  }
}

 void mouseReleased() {
  // [鼠标释放事件处理代码]
}
