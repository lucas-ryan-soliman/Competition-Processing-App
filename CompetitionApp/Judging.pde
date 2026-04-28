class JudgingState implements AppState {
  @Override
  public void InitState() {
    for(Team t : ALL_TEAMS) {
      t.SetScore(0);
    }
  }
  
  @Override
  public void TickState() {
    background(255, 255, 0);
  }
}
