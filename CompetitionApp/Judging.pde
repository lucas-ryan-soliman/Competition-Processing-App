// TODO: Make this app state only input scores for each side not each team.

class JudgingState implements AppState {
  class ScoreInput {
    public TextInput scoreInput;
    public Team inputTarget;
  }

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
      
      if(keyPressed && key == '0') {
        for(ScoreInput j : judgedTeams) {
          j.scoreInput.ClearData();
        }
      }
      
      // Draw the rectangle
      stroke(strokeColor);
      fill(0, 0, 0, 128);
      rect(posX, posY, w, h);
      
      fill(255, 255, 255, 255);
      textSize(50);
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
    screenWidth = width;
    screenHeight = height;

    RenderUI();
    
    for(ScoreInput si : judgedTeams) {
      si.inputTarget.SetScore(si.scoreInput.GetData());
    }
  }
}
