final int TEAM_SELECTION = 0;
final int MID_GAME = 1;
final int JUDGING = 2;
final int RESULTS = 3;


// Some useful definitions to streamline workflow of developing UI/UX
interface AppState {
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
  
  private String teamName;
  private int teamState;
}

// Global state variables
final HashMap<Integer, AppState> appStateHandlers = new HashMap<Integer, AppState>(); 
{
  appStateHandlers.put(TEAM_SELECTION, new TeamSelection());
  appStateHandlers.put(MID_GAME, new TeamSelection());
  appStateHandlers.put(JUDGING, new TeamSelection());
  appStateHandlers.put(RESULTS, new TeamSelection());
}

int state;
boolean n_keyState = false;

// Main functions
void setup() {
  state = TEAM_SELECTION;
  fullScreen();
}

void keyPressed() {
  //Key Control for advancing states
  if(key == 'n' && !n_keyState) {
    n_keyState = true;
    state += 1;
    if(state == RESULTS + 1) {
      state = 0;
    }
  }
}

void draw() {
  switch(state) {
    case TEAM_SELECTION: break;
    case MID_GAME: break;
    case JUDGING: break;
    case RESULTS: break;
  }
}
