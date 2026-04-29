class ResultsState implements AppState {
  private final int gridColumns = 2;
  private final int gridRows = 6;
  
  private final int scoreUIPadding = 20;
  
  private void DrawInGrid(int c, int r, String contents, color strokeColor, color fillColor, color txtColor) {
    if(r == gridRows) {
      return;
    }
    
    if(c == gridRows) {
      return;
    }
    
    int gridWidth = width / gridColumns;
    int gridHeight = height / gridRows;
    
    // Calculate padded dimensions
    int posX = gridWidth * c + scoreUIPadding;
    int posY = gridHeight * r + scoreUIPadding;
    int w = gridWidth - 2 * scoreUIPadding;
    int h = gridHeight - 2 * scoreUIPadding;
    fill(fillColor);
    stroke(strokeColor);
    rect(posX, posY, w, h);
    
    fill(txtColor);
    text(contents, posX, posY, w, h);
  }
  
  @Override
  public void InitState() {
  }
  
  @Override
  public void TickState() {
    background(0, 0, 0);
    
    // Render the individual scores
    int numA = 0;
    int numB = 0;
    int scoreSumA = 0;
    int scoreSumB = 0;
    for(int i = 0; i < ALL_TEAMS.length; i++) {
      Team t = ALL_TEAMS[i];
      if(t.GetState() == Team.ASSIGNED_TEAMNONE) {
        continue;
      }

      color strokeColor = t.GetState() == Team.ASSIGNED_TEAMA ? teamAColor : teamBColor;
      int c = t.GetState() == Team.ASSIGNED_TEAMA ? 0 : 1; 
      int r = t.GetState() == Team.ASSIGNED_TEAMA ? numA : numB;
      DrawInGrid(c, r, t.GetName() + ": " + t.GetScore(), strokeColor, color(0, 0, 0, 255), color(255, 255, 255, 255));
      if(t.GetState() == Team.ASSIGNED_TEAMA) { scoreSumA += t.GetScore(); }
      if(t.GetState() == Team.ASSIGNED_TEAMB) { scoreSumB += t.GetScore(); }
      if(t.GetState() == Team.ASSIGNED_TEAMA) { numA++; }
      if(t.GetState() == Team.ASSIGNED_TEAMB) { numB++; }
    }
    
    DrawInGrid(0, numA, "Team 1 Score: " + scoreSumA, teamAColor, color(0, 0, 0, 255), color(255, 255, 255, 255));
    DrawInGrid(1, numB, "Team 2 Score: " + scoreSumB, teamBColor, color(0, 0, 0, 255), color(255, 255, 255, 255));
  }
}
