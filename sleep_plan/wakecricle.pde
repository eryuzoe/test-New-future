class WakeCircle {
  PApplet parent;
  int centerX, centerY;
  int outerRadius = 400;
  int innerRadius = 300;
  int menuRadius = 200;
  int switchRadius = 100;
  int buttonRadius = 50;
  float angle = 0;
  float startAngle = 150 * (PI / 180);
  float endAngle = 150 * (PI / 180);
  WakeCircle(PApplet p) {
    parent = p;
    centerX = parent.width / 2;
    centerY = parent.height / 2;
  }

  void display() {
    drawGradientBackground();
    drawRings();
    drawButton();
    drawWhiteRectangle(centerX, centerY-140);
  }

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
  arc(centerX, centerY, outerRadius * 2, outerRadius * 2, 280 * (PI / 180), 310 * (PI / 180), PIE);
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
  }
