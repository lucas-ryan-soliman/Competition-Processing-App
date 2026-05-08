class ResultsState implements AppState {
  private final int scoreInputPadding = 10;
  
  @Override
  public void InitState() {}
  
  @Override
  public void TickState() {
    // The blue team score rect
    final int blueScoreInputX = scoreInputPadding;
    final int blueScoreInputY = scoreInputPadding;
    final int blueScoreInputW = width - 2 * scoreInputPadding;
    final int blueScoreInputH = height / 2 - scoreInputPadding;

    stroke(redTeamColor);
    fill(0, 0, 0, 128);
    rect(blueScoreInputX, blueScoreInputY, blueScoreInputW, blueScoreInputH);
    
    // The red team score rect
    final int redScoreInputX = scoreInputPadding;
    final int redScoreInputY = height / 2 + scoreInputPadding;
    final int redScoreInputW = width - 2 * scoreInputPadding;
    final int redScoreInputH = height / 2 - 2 * scoreInputPadding;
    
    stroke(blueTeamColor);
    fill(0, 0, 0, 128);
    rect(redScoreInputX, redScoreInputY, redScoreInputW, redScoreInputH);
    
    // Draw the labels
    fill(255, 255, 255, 255);
    textAlign(CENTER, CENTER);
    
    textSize(100);
    text("Team Red Score: ", redScoreInputX, redScoreInputY, redScoreInputW, redScoreInputH / 4);
    text("Team Blue Score: ", blueScoreInputX, blueScoreInputY, blueScoreInputW, blueScoreInputH / 4);
    
    textSize(400);
    text("" + redTeamScore, redScoreInputX, redScoreInputY + redScoreInputH / 5, redScoreInputW, redScoreInputH - redScoreInputH / 4);
    text("" + blueTeamScore, blueScoreInputX, blueScoreInputY + blueScoreInputH / 5, blueScoreInputW, blueScoreInputH - blueScoreInputH / 4);
  }
}
