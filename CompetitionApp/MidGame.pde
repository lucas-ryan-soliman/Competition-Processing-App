class MidGameState implements AppState {
  private final int gameTime = 120;
  private int remainingTime = 0;
  private int lastTime = 0;
  
  @Override
  public void InitState() {
    remainingTime = gameTime;
  }
  
  @Override
  public void TickState() {
    if(lastTime != second()) {
      remainingTime--;
      lastTime = second();
    }
    
    if(remainingTime < 0) {
      remainingTime = 0;
    }
    
    int minutes = remainingTime / 60;
    int seconds = remainingTime % 60;
    
    fill(255, 255, 255);
    textAlign(CENTER, CENTER);
    textSize(700);
    text(minutes + ":" + String.format("%02d", seconds), width / 2, height / 2); 
  }
}
