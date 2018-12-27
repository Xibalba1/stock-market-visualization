class View3 extends PApplet {

  Controller myController;
  DayChart myDayChart;
  boolean isDayChartSet;

  public void settings() {
    this.size(800, 600);
    this.isDayChartSet = false;
  }
  public void setup() {
  }
  public void draw() {
    background(255);
    if (isDayChartSet) {
      myDayChart.drawChart(this);
    }
  }

  // setters
  public void setController(Controller pController) {
    this.myController = pController;
  }

  public void setDayChart(DayChart pDayChart) {
    this.myDayChart = pDayChart;
    this.isDayChartSet = true;
  }
}