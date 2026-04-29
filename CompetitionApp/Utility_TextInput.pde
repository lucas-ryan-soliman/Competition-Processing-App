class TextInput {
  private final float inputTimeBuffer = 0.2f;
  private float currentTimeBuffer;
  private boolean firstInputPass;
  private String data;
  private int x;
  private int y;
  private int w;
  private int h;

  private boolean mouseInRect() {
    boolean inXRange = x <= mouseX && mouseX <= x + w;
    boolean inYRange = y <= mouseY && mouseY <= y + h;
    return inXRange && inYRange;
  }

  public TextInput() {
    x = 0;
    y = 0;
    w = 0;
    h = 0;
    
    currentTimeBuffer = 0.0f;
    data = "";
  }

  public void SetRect(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  private void ReadData() {
    if (focusedInstance != this) {
      return;
    }

    if (keyPressed) {        
      if (firstInputPass) {
        if (key == BACKSPACE) {
          if (data.length() > 0) { data = data.substring(0, data.length() - 1); }
        } else if (key != CODED) {
          if (key >= '0' || key <= '9' && key != ENTER) {
            data += key;
          }
        }

        firstInputPass = false;
      }
      
      if (!firstInputPass && currentTimeBuffer > 0) {
        currentTimeBuffer -= deltaTime;
        return;
      }

      // Basic input reading
      if (key == BACKSPACE) {
        if (data.length() > 0) { data = data.substring(0, data.length() - 1); }
      } else if (key != CODED) {
        if (key >= '0' || key <= '9') {
          data += key;
        }
      }
      
      return;
    }
    
    // Reset the input pass
    firstInputPass = true;
    currentTimeBuffer = inputTimeBuffer;
  }

  public Integer GetData() {
    int res = 0;
    try {
      res = Integer.parseInt(data);
    } catch(Exception e) {
      return 0;
    }
    
    return res;
  }

  public void Tick() {
    if (mouseInRect() && mousePressed && mouseButton == LEFT) {
      focusedInstance = this;
    }

    ReadData();

    fill(0, 0, 0);
    stroke(255, 255, 255);
    rect(x, y, w, h);

    fill(255, 255, 255, 255);
    textSize(80);
    textAlign(CENTER, CENTER);
    text(data, x, y, w, h);
  }
}
