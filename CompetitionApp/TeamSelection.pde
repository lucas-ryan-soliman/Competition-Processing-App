class TeamSelection implements AppState {
  private final Team[] allTeams = {
    new Team("Team 1", Team.ASSIGNED_TEAMNONE),
    new Team("Team 2", Team.ASSIGNED_TEAMNONE),
    new Team("Team 3", Team.ASSIGNED_TEAMNONE),
    new Team("Team 4", Team.ASSIGNED_TEAMNONE),
    new Team("Team 5", Team.ASSIGNED_TEAMNONE),
    new Team("Team 6", Team.ASSIGNED_TEAMNONE),
    new Team("Team 7", Team.ASSIGNED_TEAMNONE),
    new Team("Team 8", Team.ASSIGNED_TEAMNONE),
    new Team("Team 9", Team.ASSIGNED_TEAMNONE)
  };
  
  @Override
  public void TickState() {
    
  }
}
