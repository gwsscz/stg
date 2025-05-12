int x=480,y=1180;
// 四个方向按键状态
boolean leftPressed = false;
boolean rightPressed = false;
boolean upPressed = false;
boolean downPressed = false;
boolean over = false;
int Speed=8;
int playerSize = 20;  // 玩家尺寸，用于碰撞判断,一开始给的30
int blood = 3;  // 玩家血量
PImage heart; // 用于存储爱心图片
int heartSize = 40; // 爱心的大小
int heartSpacing = 10; // 爱心之间的间距

//其他物体相关函数
int num=120;
int num2=1;
int[] enemyX = new int[num];  // 敌人的X坐标数组
int[] enemyY = new int[num];  // 敌人的Y坐标数组
int[] enemySpeed = new int[num]; // 敌人的速度数组
int[] healX = new int[num2];  // 血包的X坐标数组
int[] healY = new int[num2];  // 血包的Y坐标数组
int[] healSpeed = new int[num2]; // 血包的速度数组
int enemySize = 10;  // 敌人的尺寸
int healSize = 10;  // 血包的尺寸

int startTime;
boolean gameStarted = false; // 新增：标记游戏是否开始

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void setup(){
size(960,1280);
  heart = loadImage("heart.png"); // 加载爱心图片
     startTime = millis();  // 记录开始时间
  // 初始化敌人位置和速度
  for (int i = 0; i < num; i++) {
    enemyX[i] = (int) random(0, width);  // 随机生成X位置
    enemyY[i] = (int) random(-1000, -50); // 随机生成Y位置（敌人从上方出现）
    enemySpeed[i] = (int) random(4, 6);  // 随机生成敌人速度
  }
    for (int i = 0; i < num2; i++) {
    healX[i] = (int) random(0, width);  // 随机生成血包X位置
    healY[i] = (int) random(-1000, -50); // 随机生成血包Y位置（血包从上方出现）
    healSpeed[i] = (int) random(4, 6);  // 随机生成血包速度
}
}

void draw(){
     textSize(32);
    if (!gameStarted) {
    // 显示 START 按钮
    drawStartScreen();
    return; // 不执行后续游戏逻辑
  }

  if(!over){
background(255);
  }
   if (over) {
    drawGameOver();
    return;
  }
strokeWeight(3);
//heartCount();
triangle(x-15,y+15,x+15,y+15,x,y-15);
springBack();//出界弹回模块
moveControl();//移动控制模块
enemy();//敌人模块
heal();//血包模块
heartCount();// 绘制爱心
score();//计分模块
difficulty();//难度模块
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// 难度模块
void difficulty(){
    if (millis() > 5000) {  // 如果游戏开始超过5秒
    }
  }

// 绘制爱心函数
void heartCount(){
  if(blood==0){
    return; // 如果血量为0，不绘制爱心
  }
  for (int i = 0; i < blood; i++) { // 根据血量绘制爱心
    image(heart, 50 + i * (heartSize + heartSpacing), 50, heartSize, heartSize);
  }
}
// 游戏结束画面
void drawGameOver() {
  textAlign(CENTER, CENTER);
  textSize(80);
  fill(255, 0, 0);
  text("GAME OVER", width/2, height/2);
}

// 绘制 START 画面
void drawStartScreen() {
  textAlign(CENTER, CENTER);
  textSize(80);
  fill(0);
  text("↓CLICK TO START↓", width/2, height/2 - 50);
  
  // 绘制一个按钮
  fill(240);
  rectMode(CENTER);
  strokeWeight(5); // 增加边框宽度
  rect(width/2, height/2 + 100, 200, 80, 10);
  fill(0);
  textSize(40);
  text("START", width/2, height/2 + 100);
}

void mousePressed() {
  if (!gameStarted) {
    // 检查是否点击了 START 按钮
    if (mouseX > width/2 - 100 && mouseX < width/2 + 100 && 
        mouseY > height/2 + 60 && mouseY < height/2 + 140) {
      gameStarted = true;
      startTime = millis(); // 开始计时
    }
  }
}



//计数模块
void score(){
int elapsedTime = (millis() - startTime) / 1000;
  int score =(int)(elapsedTime/0.6);
  fill(0);
  textAlign(LEFT);
  textSize(32);
  text("Score: " + score, 800,50);
  text("Blood:" + blood, 800, 80); // 显示血量
}

//血包模块
void heal(){
  for (int i = 0; i < num2; i++) {
    updateHeal(i);  // 更新血包位置模块！
    displayHeal(i); // 绘制血包模块！
    checkHealCollision(i);  // 检测碰撞模块！
  }
}


// 更新血包位置
void updateHeal(int i){
  healY[i] += healSpeed[i];  // 更新Y位置
  if (healY[i] > height) {  // 如果血包超出屏幕
    healY[i] = (int) random(-200, -50);  // 从屏幕上方重新随机生成位置
    healX[i] = (int) random(0, width);   // 随机生成X位置
  }
}
// 检测血包碰撞
void checkHealCollision(int i){
  float distance = dist(x, y, healX[i], healY[i]);  // 计算玩家和血包之间的距离
  if (distance < (playerSize / 2 + healSize / 2)) {  // 如果距离小于玩家和血包半径之和，表示碰撞
    println("碰撞了血包 " + i);
    blood++;  // 玩家血量增加
    healY[i] = (int) random(-200, -50);  // 碰撞后，血包重新随机生成位置
    println("当前血量: " + blood);
  }
}

// 绘制血包
void displayHeal(int i){
  rectMode(CENTER);
  fill(255, 0, 0);
  rect(healX[i], healY[i], healSize, healSize);  // 绘制血包
}

//敌人模块
void enemy(){
  for (int i = 0; i < num; i++) {
    updateEnemy(i);  // 更新敌人位置模块！
    displayEnemy(i); // 绘制敌人模块！
    checkCollision(i);  // 检测碰撞模块！
  }
}


// 更新敌人位置
void updateEnemy(int i){
  enemyY[i] += enemySpeed[i];  // 更新Y位置
  if (enemyY[i] > height) {  // 如果敌人超出屏幕
    enemyY[i] = (int) random(-200, -50);  // 从屏幕上方重新随机生成位置
    enemyX[i] = (int) random(0, width);   // 随机生成X位置
  }
}

// 绘制敌人
void displayEnemy(int i){
  rectMode(CENTER);
  fill(150);
  rect(enemyX[i], enemyY[i], 10, 10);  // 绘制敌人
}


//移动控制模块
void moveControl(){
if(upPressed){
y-=Speed;
}
if(downPressed){
y+=Speed;
}
if(leftPressed){
x-=Speed;
}
if(rightPressed){
x+=Speed;
}
}


//出界弹回模块
void springBack(){
if(y-15<0){
y=15;
}
if(y+15>1280){
y=1265;
}
if(x+15>960){
x=945;
}
if(x-15<0){
x=15;
}
}

// 碰撞检测函数模块
void checkCollision(int i){
  float distance = dist(x, y, enemyX[i], enemyY[i]);  // 计算玩家和敌人之间的距离
  if (distance < (playerSize / 2 + enemySize / 2)) {  // 如果距离小于玩家和敌人半径之和，表示碰撞
    println("碰撞了敌人 " + i);
    blood--;  // 玩家血量减少
    enemyY[i] = (int) random(-200, -50);  // 碰撞后，敌人重新随机生成位置
    if (blood <= 0) {  // 如果血量为0，游戏结束
      over = true;
      println("游戏结束");
    } else {
      println("剩余血量: " + blood);
    }
  }
}

void keyPressed(){
if(keyCode==UP){
upPressed=true;
}
if(keyCode==DOWN){
downPressed=true;
}
if(keyCode==LEFT){
leftPressed=true;
}
if(keyCode==RIGHT){
rightPressed=true;
}
if(keyCode==SHIFT){
Speed=4;
}
}

void keyReleased(){
if(keyCode==UP){
upPressed=false;
}
if(keyCode==DOWN){
downPressed=false;
}
if(keyCode==LEFT){
leftPressed=false;
}
if(keyCode==RIGHT){
rightPressed=false;
}
if(keyCode==SHIFT){
Speed=8;
}
}
