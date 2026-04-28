final int TEAM_SELECTION = 0;
final int MID_GAME = 1;
final int JUDGING = 2;
final int RESULTS = 3;

// Some useful definitions to streamline workflow of developing UI/UX of app.
interface AppState {
  public void InitState();
  public void TickState();
}

class Team {  
  static final int ASSIGNED_TEAMA = 4;
  static final int ASSIGNED_TEAMB = 5;
  static final int ASSIGNED_TEAMNONE = 6;
  
  public Team(String name, int initState) {
    teamState = initState;
    teamName = name;
  }
  
  public String GetName() { return teamName; }
  public int GetState() { return teamState; }
  public void SetState(int state) { teamState = state; }
  public void SetScore(int score) { this.score = score; }
  public int GetScore() { return score; }
  
  public void AddToScore(int deltaScore) {
    if(score + deltaScore < 0) {
      return;
    }
    
    score += deltaScore;
  }
  
  private String teamName;
  private int teamState;
  private int score;
}

// Store the different handlers for the different states in a hashmap.
final HashMap<Integer, AppState> appStateHandlers = new HashMap<Integer, AppState>(); {
  appStateHandlers.put(TEAM_SELECTION, new TeamSelectionState());
  appStateHandlers.put(MID_GAME, new MidGameState());
  appStateHandlers.put(JUDGING, new JudgingState());
  appStateHandlers.put(RESULTS, new ResultsState());
}

final Team[] ALL_TEAMS = {
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

// Global State Variables
int state;
boolean n_keyState = false;

// Main functions
void setup() {
  state = TEAM_SELECTION;
  fullScreen();
}

void draw() {
  if(keyPressed) {
    if(key == 'n' && !n_keyState) {
      n_keyState = true;
      state += 1;
      if(state == RESULTS + 1) {
        state = 0;
      }
      
      appStateHandlers.get(state).InitState();
    }
  } else {
    n_keyState = false;
  }
  
  appStateHandlers.get(state).TickState();
}
