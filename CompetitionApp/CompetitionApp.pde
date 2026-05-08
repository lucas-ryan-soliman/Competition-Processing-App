// Imports
import java.util.Arrays;

////////////////////////////////////////////
// Simple Class and Interface Definitions //
////////////////////////////////////////////
interface AppState {
  public void InitState();
  public void TickState();
}

interface RenderableObject {
  public void Render();
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
  
  public void SetState(int state) { teamState = state; }
  public int GetState() { return teamState; }
  
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
final int APPSTATE_TEAMSELECTION = 0;
final int APPSTATE_MIDGAME = 1;
final int APPSTATE_JUDGING = 2;
final int APPSTATE_RESULTS = 3;

final int GRAPHICSSTATE_NORMAL = 4;
final int GRAPHICSSTATE_PANICKED = 5;

final int NUM_FISH = 25;
final int NUM_BUBBLES = 50;

// This hashmap contains all the different application states and their functionalities
final HashMap<Integer, AppState> appStateHandlers = new HashMap<Integer, AppState>(); {
  appStateHandlers.put(APPSTATE_TEAMSELECTION, new TeamSelectionState());
  appStateHandlers.put(APPSTATE_MIDGAME, new MidGameState());
  appStateHandlers.put(APPSTATE_JUDGING, new JudgingState());
  appStateHandlers.put(APPSTATE_RESULTS, new ResultsState());
}

// This array contains all the teams of the competition and their data
final Team[] ALL_TEAMS = {
  new Team("Adjala", Team.ASSIGNED_TEAMNONE), // 1
  new Team("Tec South", Team.ASSIGNED_TEAMNONE), // 2
  new Team("Cookstown", Team.ASSIGNED_TEAMNONE), // 3
  new Team("Tottenham", Team.ASSIGNED_TEAMNONE), // 4
  new Team("Alliston Union", Team.ASSIGNED_TEAMNONE), // 5
  new Team("Boyne River", Team.ASSIGNED_TEAMNONE), // 6
  new Team("Ernest Cumberland", Team.ASSIGNED_TEAMNONE), // 7
  new Team("Banting Memorial HS", Team.ASSIGNED_TEAMNONE), // 8
  new Team("Team RED", Team.ASSIGNED_TEAMNONE), // A
  new Team("Team BLUE", Team.ASSIGNED_TEAMNONE) // Z
};

/////////////////
// Team colors //
/////////////////
final color blueTeamColor = color(255, 0, 0);
final color redTeamColor = color(0, 0, 255);

////////////////////////////
// Global State Variables //
////////////////////////////
AppGraphics appGraphics;
TextInput focusedInstance;
boolean n_keyState;

float time;
float deltaTime;
int appState;

int blueTeamScore;
int redTeamScore;

////////////////////
// Main functions //
////////////////////
void setup() {
  appState = APPSTATE_TEAMSELECTION;
  n_keyState = false;
  frameRate(60);
  fullScreen();
  noSmooth();
  
  appGraphics = new AppGraphics(NUM_FISH, NUM_BUBBLES);
  
  deltaTime = 1f / 60f;
  appStateHandlers.get(appState).InitState();
}

void draw() {
  time = millis() / 1000.0f;
  appGraphics.RenderBackground();
  appGraphics.RenderForeground();
  
  // Listen for the advance state key.
  if(keyPressed) {
    if(key == 'n' && !n_keyState) {
      n_keyState = true;
      appState += 1;
      if(appState == APPSTATE_RESULTS + 1) {
        appState = 0;
      }
      
      // Initialize the new state.
      appStateHandlers.get(appState).InitState();
    }
  } else {
    n_keyState = false;
  }
  
  // Tick the current state.
  appStateHandlers.get(appState).TickState();
}
