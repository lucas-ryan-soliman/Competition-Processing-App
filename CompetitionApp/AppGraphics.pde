class AppGraphics {
  // Although these values conflict with the application states, these are completely encapsulated in this class
  private final int RENDERSTATE_INIT = 0;
  private final int RENDERSTATE_ACTIVE = 1;
  
  private class JellyFish implements RenderableObject {
    private int state;
    
    public JellyFish() {
      state = RENDERSTATE_INIT;
    }
    
    @Override
    public void Render() {
      
    }
  }
  
  private class Fish implements RenderableObject {
    private final FlipBook fishFlipBook;
    private final float turnSpeed = 5.0f;
    private final int drawSizeFactor = 2;
    
    private int state;
    private int minXForce, maxXForce;
    private int minYForce, maxYForce;
    
    private int xSpeed, ySpeed;
    private float relativeAngle;
    private int x, y;
    
    private float turnInterp;
    private boolean fromRight;
    private color drawColor;

    public Fish() {
      fishFlipBook = new FlipBook("Assets/Fish_Sheet.png", 1, 3);
      state = RENDERSTATE_INIT;

      minXForce = 0;
      maxXForce = 0;
      minYForce = 0;
      maxYForce = 0;
    }
    
    @Override
    public void Render() {
      if(state == RENDERSTATE_INIT) {
        drawColor = color(
          (int)(random(0, 1) * 255f),
          (int)(random(0, 1) * 255f), 
          (int)(random(0, 1) * 255f), 
          255
        );
      
        fromRight = random(0, 1) > 0.5f ? true : false;
        int speed = (int)random(100, 250);
        int minY = height / 4;
        int maxY = height - (height / 4);
        
        minYForce = -250;
        maxYForce = 250;
        
        if(fromRight) {
          minXForce = -100;
          maxXForce = -0;
          
          relativeAngle = 0;
          xSpeed = -(int)(speed * cos(relativeAngle));
          ySpeed = (int)(speed * sin(relativeAngle));
          
          x = width + fishFlipBook.GetCellWidth() * drawSizeFactor;
          y = (int)random(minY, maxY);
          
          state = RENDERSTATE_ACTIVE;
        }
        
        if(!fromRight) {
          minXForce = 25;
          maxXForce = 100;
          
          relativeAngle = 0;
          xSpeed = (int)(speed * cos(relativeAngle));
          ySpeed = (int)(speed * sin(relativeAngle));
          
          x = -fishFlipBook.GetCellWidth() * drawSizeFactor;
          y = (int)random(minY, maxY);
          
          state = RENDERSTATE_ACTIVE;
        }
      }
      
      // Calculate the independent component speeds
      xSpeed += random(minXForce, maxXForce) * deltaTime;
      ySpeed += random(minYForce, maxYForce) * deltaTime;
      relativeAngle = atan2(ySpeed, abs(xSpeed));
      
      if(xSpeed < 0) relativeAngle *= -1;
      
      // Calculate the interpolation
      float interpDir = xSpeed <= 0 ? 1.0f : -1.0f;
      turnInterp += interpDir * turnSpeed * deltaTime;
      if(turnInterp < 0) turnInterp = 0;
      if(turnInterp > 1) turnInterp = 1;
      
      // Get the frame based on its move direction
      int frameToUse = (int)round(lerp(0, 2, turnInterp));
      PImage imgToUse = fishFlipBook.GetFrame(frameToUse);

      // Render the fish
      pushMatrix();
      
      x += xSpeed * deltaTime;
      y += ySpeed * deltaTime;
      translate(x, y);
      rotate(relativeAngle);
      
      tint(drawColor);
      imageMode(CENTER);
      image(imgToUse, 0, 0, fishFlipBook.GetCellWidth() * drawSizeFactor, fishFlipBook.GetCellHeight() * drawSizeFactor);
      
      popMatrix();
      
      if(fromRight && x <= -fishFlipBook.GetCellWidth() * drawSizeFactor) {
        state = RENDERSTATE_INIT;
      }
      
      if(!fromRight && x >= width + fishFlipBook.GetCellHeight() * drawSizeFactor) {
        state = RENDERSTATE_INIT;
      }
    }
  }
  
  private class Bubble implements RenderableObject {
    private final int minBubbleRadius = 25;
    private final int maxBubbleRadius = 30;
    private final int floatForce = -120;
    private final float floatAngularVel = 1.0f;
    private final int wobbleRadius = 40;
    private final PImage bubbleTexture;
    private final PImage bubbleShineTexture;
    
    private int state;
    private int startX;
    private int x, y;
    private int yVel;
    
    private int bubbleRadius = 50;
    
    private float lifeTime;
    private float currLifeTime;
    
    private float floatRotateDir;
    private float sinOffset;
    
    private float initialDelay;
    
    public Bubble() {
      bubbleTexture = loadImage("Assets/Bubble.png");
      bubbleShineTexture = loadImage("Assets/Bubble_Shine.png");
      
      state = RENDERSTATE_INIT;
      initialDelay = random(0, 3);
    }
    
    @Override
    public void Render() {
      if(initialDelay > 0) {
        initialDelay -= deltaTime;
        return;
      }
      
      if(state == RENDERSTATE_INIT) {
        startX = (int)random(0, width);
        
        lifeTime = random(2, 4);
        currLifeTime = lifeTime;
        sinOffset = random(0, 2*PI);
        floatRotateDir = random(0, 1) > 0.5f ? 1.0f : -1.0f;
        
        y = height + bubbleRadius;
        yVel = 0;
        
        state = RENDERSTATE_ACTIVE;
        return;
      }
      
      if(currLifeTime <= 0) {
        state = RENDERSTATE_INIT;
        return;
      }
      
      // Calculate a bunch of stuff for rendering
      float lifeInterp = 1.0f - currLifeTime / lifeTime;
      float interpToUse = pow(lifeInterp, 8);
      int radiusToUse = (int)lerp(minBubbleRadius, maxBubbleRadius, interpToUse);
      float angleToUse = floatRotateDir * floatAngularVel * lifeInterp;
      float alphaMultiplier = lerp(1, 0, interpToUse);
      
      // Move and render bubble
      x = startX + (int)round(wobbleRadius * sin(time + sinOffset));
      yVel += floatForce * deltaTime;
      y += yVel * deltaTime;
      
      // Render the bubble
      pushMatrix();
      translate(x, y);
      rotate(angleToUse);
      
      imageMode(CENTER);
      tint(255, 255, 255, (int)round(128 * alphaMultiplier));
      image(bubbleTexture, 0, 0, radiusToUse * 2, radiusToUse * 2);

      popMatrix();
      
      // Render the bubble's shine
      pushMatrix();
      translate(x, y);
      imageMode(CENTER);
      
      float shineInterp = pow(lifeInterp, 10);
      float shineAlphaMultiplier = lerp(1, 0, shineInterp);
      tint(255, 255, 255, (int)round(128 * shineAlphaMultiplier));
      image(bubbleShineTexture, 0, 0, radiusToUse * 2, radiusToUse * 2);
      
      popMatrix();
      
      // Subtract from its lifetime
      currLifeTime -= deltaTime;
    }
  }
  
  private final ArrayList<RenderableObject> renderables;
  
  public AppGraphics(int numFish, int numJellyFish, int numBubbles) {
    renderables = new ArrayList<RenderableObject>();
    for(int i = 0; i < numFish; i++) {
      renderables.add(new Fish());
    }
    
    for(int i = 0; i < numJellyFish; i++) {
      renderables.add(new JellyFish());
    }
    
    for(int i = 0; i < numBubbles; i++) {
      renderables.add(new Bubble());
    }
  }
  
  public void RenderBackground() {
    background(0, 128, 128);
  }
  
  public void RenderForeground() {
    for(RenderableObject obj : renderables) {
      obj.Render();
    }
  }
}
