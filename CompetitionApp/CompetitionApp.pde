///////////////////////////////////////
// Class and Interface Definition(s) //
///////////////////////////////////////
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

////////////////////////////
// Global final variables //
////////////////////////////
final int TEAM_SELECTION = 0;
final int MID_GAME = 1;
final int JUDGING = 2;
final int RESULTS = 3;

final HashMap<Integer, AppState> appStateHandlers = new HashMap<Integer, AppState>(); {
  appStateHandlers.put(TEAM_SELECTION, new TeamSelectionState());
  appStateHandlers.put(MID_GAME, new MidGameState());
  appStateHandlers.put(JUDGING, new JudgingState());
  appStateHandlers.put(RESULTS, new ResultsState());
}

final color teamAColor = color(255, 0, 0);
final color teamBColor = color(0, 0, 255);

////////////////////////////
// Global State Variables //
////////////////////////////
final Team[] ALL_TEAMS = {
  new Team("Adjala", Team.ASSIGNED_TEAMNONE),
  new Team("Tec South", Team.ASSIGNED_TEAMNONE),
  new Team("Cookstown", Team.ASSIGNED_TEAMNONE),
  new Team("Tottenham", Team.ASSIGNED_TEAMNONE),
  new Team("Alliston Union", Team.ASSIGNED_TEAMNONE),
  new Team("Boyne River", Team.ASSIGNED_TEAMNONE),
  new Team("Ernest Cumberland", Team.ASSIGNED_TEAMNONE),
  new Team("Banting Memorial HS", Team.ASSIGNED_TEAMNONE)
};

TextInput focusedInstance;
boolean n_keyState;

float deltaTime;
int state;

////////////////////
// Main functions //
////////////////////
void setup() {
  state = TEAM_SELECTION;
  n_keyState = false;
  deltaTime = 0.0f;
  frameRate(60);
  fullScreen();
  
  deltaTime = 1f / 60f;
  appStateHandlers.get(state).InitState();
}

void draw() {
  RenderBackground();
  
  // Listen for the advance state key.
  if(keyPressed) {
    if(key == 'n' && !n_keyState) {
      n_keyState = true;
      state += 1;
      if(state == RESULTS + 1) {
        state = 0;
      }
      
      // Initialize the new state.
      appStateHandlers.get(state).InitState();
    }
  } else {
    n_keyState = false;
  }
  
  // Tick the current state.
  appStateHandlers.get(state).TickState();
  RenderForeground();
}

////////////////////////
// GRAPHICS RENDERING //
////////////////////////
void RenderBackground() {
  background(0, 0, 0, 255);
}

void RenderForeground() {
}
