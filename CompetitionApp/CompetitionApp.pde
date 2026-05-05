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

final int NUM_FISH = 50;
final int NUM_JELLYFISH = 25;
final int NUM_BUBBLES = 25;

// This class is used to render the fish, background, etc.


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
  new Team("Banting Memorial HS", Team.ASSIGNED_TEAMNONE) // 8
};

// Team colors
final color teamAColor = color(255, 0, 0);
final color teamBColor = color(0, 0, 255);

////////////////////////////
// Global State Variables //
////////////////////////////
AppGraphics appGraphics;
TextInput focusedInstance;
boolean n_keyState;

float time;
float deltaTime;
int state;

////////////////////
// Main functions //
////////////////////
void setup() {
  state = APPSTATE_TEAMSELECTION;
  n_keyState = false;
  frameRate(60);
  fullScreen();
  noSmooth();
  
  appGraphics = new AppGraphics(NUM_FISH, NUM_JELLYFISH, NUM_BUBBLES);
  
  deltaTime = 1f / 60f;
  appStateHandlers.get(state).InitState();
}

void draw() {
  time = millis() / 1000.0f;
  appGraphics.RenderBackground();
  
  // Listen for the advance state key.
  if(keyPressed) {
    if(key == 'n' && !n_keyState) {
      n_keyState = true;
      state += 1;
      if(state == APPSTATE_RESULTS + 1) {
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
  appGraphics.RenderForeground();
}
