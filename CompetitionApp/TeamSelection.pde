class TeamSelectionState implements AppState {
  // Aliasing and constants for readability  
  private final float rectPadding = 10;
  private final float textSpacing = 10;
  private final int teamDisplayHeaderFontSize = TEXTSIZE_TEAMSELECTION_TEAMHEADERDISPLAY;
  private final int teamDisplayNameFontSize = TEXTSIZE_TEAMSELECTION_TEAMNAMEDISPLAY;
  
  private int screenRight;
  private int screenMiddle;
  
  // Important state for team selection.
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
    if(t.GetState() == Team.ASSIGNED_TEAMRED) {
      return CalculateMiddle(rectPadding, screenMiddle - rectPadding);
    }
    
    if(t.GetState() == Team.ASSIGNED_TEAMBLUE) {
      return CalculateMiddle(screenMiddle + rectPadding, screenRight - 2 * rectPadding);
    }
    
    return -1;
  }
  
  private int CalculateTeamStateDisplayRectHeight(int state, int displayNameFontSize) {
    if(state == Team.ASSIGNED_TEAMNONE) {
      return -1;
    }
    
    int res = 0;
    for(Team t : ALL_TEAMS) {
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
    
    if(key >= '1' && key <= '8') {
      int index = key - '1';
      print(index);
      pointer = index;
    }
    
    if(key == 'z') {
      pointer = 8;
    }
    
    if(key == 'x') {
      pointer = 9;
    }
    
    if(key == 'r' && pointer != -1) {
      ALL_TEAMS[pointer].SetState(Team.ASSIGNED_TEAMRED);
      if(teamsAssignedBlue.contains(ALL_TEAMS[pointer])) {
        teamsAssignedBlue.remove(ALL_TEAMS[pointer]);
      }
      
      if(!teamsAssignedRed.contains(ALL_TEAMS[pointer])) {
        teamsAssignedRed.add(ALL_TEAMS[pointer]);
      }
      
      return;
    }
    
    if(key == 'b' && pointer != -1) {
      ALL_TEAMS[pointer].SetState(Team.ASSIGNED_TEAMBLUE);
      if(teamsAssignedRed.contains(ALL_TEAMS[pointer])) {
        teamsAssignedRed.remove(ALL_TEAMS[pointer]);
      }
      
      if(!teamsAssignedBlue.contains(ALL_TEAMS[pointer])) {
        teamsAssignedBlue.add(ALL_TEAMS[pointer]);
      }
      
      return;
    }
    
    if(key == '0' && pointer != -1) {
      ALL_TEAMS[pointer].SetState(Team.ASSIGNED_TEAMNONE);
    }
    
    if(key == 'c') {
      for(Team t : ALL_TEAMS) {
        t.SetState(Team.ASSIGNED_TEAMNONE);
      }
      
      return;
    }
  }
  
  private void RenderUI() {
    screenRight = width;
    screenMiddle = width / 2;
    
    // Calculate rectangles
    final int teamRedRectHeight = CalculateTeamStateDisplayRectHeight(Team.ASSIGNED_TEAMRED, teamDisplayNameFontSize);
    final int teamBlueRectHeight = CalculateTeamStateDisplayRectHeight(Team.ASSIGNED_TEAMBLUE, teamDisplayNameFontSize);
    
    // Draw the left rectangle containing teams from team 1
    fill(0, 0, 0, 128);
    stroke(0);
    rect(rectPadding, rectPadding, screenMiddle - rectPadding, teamDisplayHeaderFontSize + rectPadding + teamRedRectHeight + textSpacing);
    
    // Draw the right rectangle containing teams from team 2
    fill(0, 0, 0, 128);
    rect(screenMiddle + rectPadding, rectPadding, screenMiddle - 2 * rectPadding, teamDisplayHeaderFontSize + rectPadding + teamBlueRectHeight + textSpacing);
    
    // Draw the text
    fill(255, 255, 255, 255);
    textAlign(CENTER);
    textSize(teamDisplayHeaderFontSize);
    
    // Draw the headers
    text("= Team Red =", CalculateMiddle(rectPadding, screenMiddle - rectPadding), rectPadding + teamDisplayHeaderFontSize);
    text("= Team Blue =", CalculateMiddle(screenMiddle + rectPadding, screenRight - 2 * rectPadding), rectPadding + teamDisplayHeaderFontSize);
    
    // Render the blue side
    int countTeamBlue = 0;
    for(Team t : teamsAssignedBlue) {
      float x = CalculateCenterAlignment(t);
      float y = 0f;
      fill(blueTeamColor);
      y = CalculateVerticalTextOffset(teamDisplayNameFontSize + textSpacing, teamDisplayHeaderFontSize, countTeamBlue);
      countTeamBlue++;
      
      if(t.GetName() == "Banting Memorial HS") {
        fill(255, 215, 0);
      }

      textSize(teamDisplayNameFontSize);
      textAlign(CENTER);
      text(t.GetName(), x, y);
    }
    
    int countTeamRed = 0;
    for(Team t : teamsAssignedRed) {
      float x = CalculateCenterAlignment(t);
      float y = 0f;
      fill(redTeamColor);
      y = CalculateVerticalTextOffset(teamDisplayNameFontSize + textSpacing, teamDisplayHeaderFontSize, countTeamRed);
      countTeamRed++;
      
      if(t.GetName() == "Banting Memorial HS") {
        fill(255, 215, 0);
      }

      textSize(teamDisplayNameFontSize);
      textAlign(CENTER);
      text(t.GetName(), x, y);
    }
  }
  
  @Override
  public void InitState() {
    for(Team t : ALL_TEAMS) {
      t.SetState(Team.ASSIGNED_TEAMNONE);
    }
    
    teamsAssignedBlue.clear();
    teamsAssignedRed.clear();
  }
  
  @Override
  public void TickState() {
    // Calculate the aliases used for rendering
    screenMiddle = width / 2;
    screenRight = width;
    
    // Listen for user input
    ListenToInput();
    
    // Render the important stuff
    RenderUI();
  }
}
