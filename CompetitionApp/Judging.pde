class JudgingState implements AppState {
  private final int scoreInputPadding = 10;
  private TextInput blueTeamScoreInput;
  private TextInput redTeamScoreInput;
  
  public JudgingState() {
    blueTeamScoreInput = new TextInput();
    redTeamScoreInput = new TextInput();
  }
  
  private void RenderUI() {
    // The blue team score rect
    final int blueScoreInputX = scoreInputPadding;
    final int blueScoreInputY = scoreInputPadding;
    final int blueScoreInputW = width - 2 * scoreInputPadding;
    final int blueScoreInputH = height / 2 - scoreInputPadding;
    blueTeamScoreInput.SetRect(blueScoreInputX + blueScoreInputW / 2, blueScoreInputY, blueScoreInputW / 2, blueScoreInputH);
    
    stroke(redTeamColor);
    fill(0, 0, 0, 128);
    rect(blueScoreInputX, blueScoreInputY, blueScoreInputW, blueScoreInputH);
    
    // The red team score rect
    final int redScoreInputX = scoreInputPadding;
    final int redScoreInputY = height / 2 + scoreInputPadding;
    final int redScoreInputW = width - 2 * scoreInputPadding;
    final int redScoreInputH = height / 2 - 2 * scoreInputPadding;
    redTeamScoreInput.SetRect(redScoreInputX + redScoreInputW / 2, redScoreInputY, redScoreInputW / 2, redScoreInputH);
    
    stroke(blueTeamColor);
    fill(0, 0, 0, 128);
    rect(redScoreInputX, redScoreInputY, redScoreInputW, redScoreInputH);
    
    // Draw the labels
    textAlign(CENTER, CENTER);
    fill(255, 255, 255, 255);
    stroke(255, 255, 255, 255);
    text("Team Red Score: ", redScoreInputX, redScoreInputY, redScoreInputW / 2, redScoreInputH);
    text("Team Blue Score: ", blueScoreInputX, blueScoreInputY, blueScoreInputW / 2, blueScoreInputH);
  }

  @Override
  public void InitState() {
    blueTeamScoreInput.ClearData();
    redTeamScoreInput.ClearData();
    focusedInstance = null;
    
    blueTeamScore = 0;
    redTeamScore = 0;
  }

  @Override
  public void TickState() {
    if(keyPressed && key == '0') {
      blueTeamScoreInput.ClearData();
      redTeamScoreInput.ClearData();
    }
    
    blueTeamScoreInput.Tick();
    redTeamScoreInput.Tick();
    
    redTeamScore = redTeamScoreInput.GetData();
    blueTeamScore = blueTeamScoreInput.GetData();
    RenderUI();
  }
}
