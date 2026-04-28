class TeamSelectionState implements AppState {
  // Aliasing and constants for readability  
  private final color teamAColor = color(255, 0, 0);
  private final color teamBColor = color(0, 0, 255);
  
  private final float rectPadding = 20;
  private final float textSpacing = 10;
  private final int teamDisplayHeaderFontSize = 40;
  private final int teamDisplayNameFontSize = 20;
  
  private int screenMiddle;
  private int screenRight;
  
  // Important state variable
  private int pointer;
  
  TeamSelectionState() {
    pointer = -1;
  }
  
  private float CalculateMiddle(float l, float r) {
    return (l + r) / 2f;
  }
  
  private float CalculateVerticalTextOffset(float fontSize, float headerFontSize, int indexPos) {
    return rectPadding + headerFontSize + (indexPos + 1) * fontSize;
  }
  
  private float CalculateCenterAlignment(Team t) {
    if(t.GetState() == Team.ASSIGNED_TEAMA) {
      return CalculateMiddle(rectPadding, screenMiddle - rectPadding);
    }
    
    if(t.GetState() == Team.ASSIGNED_TEAMB) {
      return CalculateMiddle(screenMiddle + rectPadding, screenRight - 2 * rectPadding);
    }
    
    return -1;
  }
  
  private int CalculateTeamStateDisplayRectHeight(int state, int displayNameFontSize) {
    if(state == Team.ASSIGNED_TEAMNONE) {
      return -1;
    }
    
    int res = 0;
    for(Team t : Team.ALL_TEAMS) {
      if(t.GetState() == state) {
        res += displayNameFontSize + textSpacing;
      }
    }
    
    return res;
  }
  
  private void ListenToInput() {
    if(!keyPressed) {
      return;
    }
    
    if(key >= '1' && key <= '9') {
      int index = key - '1';
      print(index);
      pointer = index;
    }
    
    if(key == 'r' && pointer != -1) {
      Team.ALL_TEAMS[pointer].SetState(Team.ASSIGNED_TEAMA);
      return;
    }
    
    if(key == 'b' && pointer != -1) {
      Team.ALL_TEAMS[pointer].SetState(Team.ASSIGNED_TEAMB);
      return;
    }
    
    if(key == '0' && pointer != -1) {
      Team.ALL_TEAMS[pointer].SetState(Team.ASSIGNED_TEAMNONE);
    }
    
    if(key == 'c') {
      for(Team t : Team.ALL_TEAMS) {
        t.SetState(Team.ASSIGNED_TEAMNONE);
      }
      
      return;
    }
  }
  
  private void RenderBackground() {
    
  }
  
  private void RenderUI() {
    background(100, 0, 0);
    final int teamARectHeight = CalculateTeamStateDisplayRectHeight(Team.ASSIGNED_TEAMA, teamDisplayNameFontSize);
    final int teamBRectHeight = CalculateTeamStateDisplayRectHeight(Team.ASSIGNED_TEAMB, teamDisplayNameFontSize);
    
    // Draw the left rectangle containing teams from team 1
    fill(0, 0, 0, 128);
    rect(rectPadding, rectPadding, screenMiddle - rectPadding, teamDisplayHeaderFontSize + rectPadding + teamARectHeight);
    
    // Draw the right rectangle containing teams from team 2
    fill(0, 0, 0, 128);
    rect(screenMiddle + rectPadding, rectPadding, screenRight - 2 * rectPadding, teamDisplayHeaderFontSize + rectPadding + teamBRectHeight);
    
    // Draw the text
    fill(255, 255, 255, 255);
    textAlign(CENTER);
    textSize(teamDisplayHeaderFontSize);
    
    // Draw the headers
    text("= Team 1 =", CalculateMiddle(rectPadding, screenMiddle - rectPadding), rectPadding + teamDisplayHeaderFontSize);
    text("= Team 2 =", CalculateMiddle(screenMiddle + rectPadding, screenRight - 2 * rectPadding), rectPadding + teamDisplayHeaderFontSize);
    
    // Draw the teams under their corresponding teams
    int countTeamA = 0;
    int countTeamB = 0;
    for(int i = 0; i < Team.ALL_TEAMS.length; i++) {
      Team t = Team.ALL_TEAMS[i];
      if(t.GetState() == Team.ASSIGNED_TEAMNONE) {
        continue;
      }
      
      float x = CalculateCenterAlignment(t);
      float y = 0f;
      if(t.GetState() == Team.ASSIGNED_TEAMA) {
        fill(teamAColor);
        y = CalculateVerticalTextOffset(teamDisplayNameFontSize + textSpacing, teamDisplayHeaderFontSize, countTeamA);
        countTeamA++;
      }
      
      if(t.GetState() == Team.ASSIGNED_TEAMB) {
        fill(teamBColor);
        y = CalculateVerticalTextOffset(teamDisplayNameFontSize + textSpacing, teamDisplayHeaderFontSize, countTeamB);
        countTeamB++;
      }

      textSize(teamDisplayNameFontSize);
      textAlign(CENTER);
      text(t.GetName() + " (" + (i+1) + ")" , x, y);
    }
  }
  
  @Override
  public void InitState() {
    for(Team t : Team.ALL_TEAMS) {
      t.SetState(Team.ASSIGNED_TEAMNONE);
    }
  }
  
  @Override
  public void TickState() {
    screenMiddle = width / 2;
    screenRight = width;
    
    // Listen for user input
    ListenToInput();
    
    // Render the important stuff
    RenderBackground();
    RenderUI();
  }
}
