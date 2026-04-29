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
  SetupGraphics();
  
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
float sandY;
ArrayList<Fish> fishList;
ArrayList<Jelly> jellyList;
ArrayList<Bubble> bubbleList;

Crab crab;
ScubaDiver diver;

void SetupGraphics() {
  sandY = height - 80;

  fishList = new ArrayList<Fish>();
  jellyList = new ArrayList<Jelly>();
  bubbleList = new ArrayList<Bubble>();

  for (int i = 0; i < 15; i++) {
    fishList.add(new Fish(random(width), random(100, sandY - 50)));
  }

  for (int i = 0; i < 10; i++) {
    jellyList.add(new Jelly(random(width), random(50, sandY - 100)));
  }

  for (int i = 0; i < 50; i++) {
    bubbleList.add(new Bubble(random(width), random(height)));
  }

  crab = new Crab(width/2, sandY + 30);
  diver = new ScubaDiver(-100, random(150, sandY - 150));
}

void DrawSand() {
  noStroke();
  fill(194, 178, 128);
  rect(0, sandY, width, height - sandY);
}

void RenderBackground() {
  background(20, 100, 180);
  DrawSand();
}

void RenderForeground() {
  for (Bubble b : bubbleList) {
    b.update();
    b.display();
  }

  for (Fish f : fishList) {
    f.update();
    if (f.y < sandY - 10) f.display();
  }

  for (Jelly j : jellyList) {
    j.update();
    if (j.y < sandY - 20) j.display();
  }

  diver.update();
  diver.display();

  DrawSand();

  crab.update();
  crab.display();
}
