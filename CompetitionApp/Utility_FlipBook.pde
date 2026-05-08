class FlipBook {
  private final PImage flipbookImage;
  private final PImage[] flipBookFrames;
  private final int rowStep;
  private final int columnStep;
  
  public FlipBook(String imgPath, int rows, int columns) {
    flipbookImage = loadImage(imgPath);
    columnStep = flipbookImage.width / columns;
    rowStep = flipbookImage.height / rows;
    
    flipBookFrames = new PImage[rows * columns];
    for(int i = 0; i < rows * columns; i++) {
      int r = i / columns;
      int c = i % columns;
      
      int posX = c * columnStep;
      int posY = r * rowStep;
      flipBookFrames[i] = flipbookImage.get(posX, posY, columnStep, rowStep);
    }
  }
  
  public int GetCellWidth() {
    return columnStep;
  }
  
  public int GetCellHeight() {
    return rowStep;
  }
  
  public PImage GetFrame(int frame) {
    return flipBookFrames[frame];
  }
}
