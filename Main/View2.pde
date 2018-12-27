class View2 extends PApplet {

  private RadialTSChart myRadialTSChart;
  private boolean isRadialTSChartSet;
  private Controller myController;
  private boolean isInvalidDateClickSelection;

  public void settings() {
    this.size(640, 800);
    this.isRadialTSChartSet = false;
    this.isInvalidDateClickSelection = false;
  }

  public void setup() {
  }
  public void draw() {
    if (this.isRadialTSChartSet) {
      myRadialTSChart.drawChart(this);
    }
    if (this.isInvalidDateClickSelection) {
      this.drawInvalidDateWarning();
    }
  }

  // setters
  public void setController(Controller pController) {
    this.myController = pController;
  }

  public void setRadialChart(RadialTSChart pRadialTSChart) {
    this.myRadialTSChart = pRadialTSChart;
    this.isRadialTSChartSet = true;
  }

  public void mouseClicked() {
    if (isRadialTSChartSet) {
      if (myRadialTSChart.getIsCollision()) {

        String pStockSymbol = myController.getRadialTSChartStockSymbol();
        boolean isValidCollisionDate = myController.getIsValidCollisionDate();
        if (isValidCollisionDate) {
          String pDate = myController.getCollisionDate();
          println("Loading 1d line chart for " + pStockSymbol + "."); 
          myController.createView3DayChart(myController.getView3(), pStockSymbol, pDate);
          this.isInvalidDateClickSelection = false;
        } else {
          this.isInvalidDateClickSelection = true;
        }
      }
    }
  }

  public void drawInvalidDateWarning() {
    this.textAlign(CENTER);
    this.textSize(20);
    fill(255,0,0);
    this.text("INVALID DATE SELECTION.\nPLEASE SELECT A DATE WITHIN THE LAST 30 DAYS.", this.width/2, this.height-100);
    fill(0);
    this.textAlign(LEFT);
    
  }
}