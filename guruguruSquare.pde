import java.util.Calendar;

PImage source;

float radius = 10;     // 最初の四角の(直径/2)
float addRadius = 3.0; //線と線の間隔（数字が小さいと狭い）
PVector[] vertex = {};
int vc = 0;
float step = 2.0; //線が進む距離 
boolean b = true;
float x, y, nextx, nexty;
float thickness = 1.5;  // 線の太さの最小値
float thickMax = 7;   // 線の太さの最大値

void setup() {
  frameRate(240);
  size(800, 800);
  //background(241, 240, 238);
  background(240, 240, 241);
  fill(88, 97, 116, 200);
  noStroke();

  source = loadImage("image.png"); // 画像をロード
  source.resize(width, height);
  source.loadPixels();

  int centx = width/2;
  int centy = height/2;
  float d = dist(width/2, height/2, 50, 50);
  float lastRadius = d; // 最後の四角の(直径/2)
  float rot = ((lastRadius) / addRadius ) * 90;

  //四角の頂点を配列に代入
  float lastx = -999;
  for (float ang = 45; ang <= 45+rot; ang += 90) {
    radius += addRadius;
    float rad = radians(ang);
    float x0 =  centx + (radius*cos(rad));
    float y0 = centy + (radius* sin(rad));
    if ( lastx > -999) {
      vertex = (PVector[]) append(vertex, new PVector(x0, y0));
    }
    lastx = x0;
  }
}

void draw() {
  if (b) {
    x = vertex[vc].x;
    y = vertex[vc].y;
    nextx = vertex[vc+1].x;
    nexty = vertex[vc+1].y;
  }
  
  b = false;
  float dx = nextx - x;
  float dy = nexty - y;
  int pos = (int(y) * source.width) + int(x); // 画像の色を取得
  color c = source.pixels[pos]; // 暗い色を太い線に、明るい色を細い線にする
  float dim = map(brightness(c), 0, 255, thickMax, thickness);
  ellipse(x, y, dim, dim); //線を描く
  
  float adx = abs(dx);
  float ady = abs(dy);
  if (adx>0) {
    if (adx < step) {
      x += dx;
    } else {
      x += (dx/adx)*step;
    }
  } 
  
  if (ady>0) {
    if (ady < step) {
      y += dy;
    } else {
      y += (dy/ady)*step;
    }
  } 
  
  if ((abs(dx)<=0) && (abs(dy)<=0)) { //線が角まで来たら
  if (vc == vertex.length-2){
    noLoop();
  }
    b = true;
    vc += 1;
  }
}

void keyPressed() {
  if (key == 's' || key == 'S')saveFrame(timestamp()+"_####.png");
}


String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
