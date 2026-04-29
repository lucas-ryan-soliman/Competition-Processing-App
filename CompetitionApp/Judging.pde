class JudgingState implements AppState {
  class ScoreInput {
    public TextInput scoreInput;
    public Team inputTarget;
  }

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
      
      return res; //
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

  public TextInput focusedInstance;
  private final int scoreUIPadding = 20;
  private final int gridColumns = 2;
  private final int gridRows = 5;

  private ArrayList<ScoreInput> judgedTeams;
  private int screenHeight;
  private int screenWidth;

  private void RenderUI() {
    int numA = 0;
    int numB = 0;
    for (int i = 0; i < judgedTeams.size(); i++) {
      Team t = judgedTeams.get(i).inputTarget;
      TextInput si = judgedTeams.get(i).scoreInput;
      if (t.GetState() == Team.ASSIGNED_TEAMNONE) {
        continue;
      }

      // Color to apply onto border
      color strokeColor = ALL_TEAMS[i].GetState() == Team.ASSIGNED_TEAMA ? teamAColor : teamBColor;

      // Calculate row and column and dimensions
      int row = t.GetState() == Team.ASSIGNED_TEAMA ? numA : numB;
      int col = t.GetState() == Team.ASSIGNED_TEAMA ? 0 : 1;
      int gridWidth = screenWidth / gridColumns;
      int gridHeight = screenHeight / gridRows;

      // Calculate padded dimensions
      int posX = gridWidth * col + scoreUIPadding;
      int posY = gridHeight * row + scoreUIPadding;
      int w = gridWidth - 2 * scoreUIPadding;
      int h = gridHeight - 2 * scoreUIPadding;
      
      si.SetRect(posX + w / 2, posY, w / 2, h);
      si.Tick();

      // Draw the rectangle
      stroke(strokeColor);
      fill(0, 0, 0, 128);
      rect(posX, posY, w, h);
      
      fill(255, 255, 255, 255);
      textSize(80);
      textAlign(CENTER, CENTER);
      text(t.GetName(), posX, posY, w / 2, h);
      
      if(t.GetState() == Team.ASSIGNED_TEAMA) { numA++; }
      if(t.GetState() == Team.ASSIGNED_TEAMB) { numB++; }
    }
  }

  @Override
    public void InitState() {
    if (judgedTeams == null) {
      judgedTeams = new ArrayList<ScoreInput>();
    }

    judgedTeams.clear();
    for (Team t : ALL_TEAMS) {
      ScoreInput si = new ScoreInput();
      si.scoreInput = new TextInput();
      si.inputTarget = t;

      judgedTeams.add(si);
      t.SetScore(0);
    }
  }

  @Override
    public void TickState() {
    background(128, 0, 0);
    screenWidth = width;
    screenHeight = height;

    RenderUI();
    
    for(ScoreInput si : judgedTeams) {
      si.inputTarget.SetScore(si.scoreInput.GetData());
    }
  }
}
