class Controller { //<>//

  private Model myModel;
  private View1 myView1;
  private View2 myView2;
  private View3 myView3;

  public Controller() {
    myView1 = new View1();
    myView2 = new View2();
    myView3 = new View3();

    PApplet.runSketch(new String[]{"1"}, myView1); // run the sketch that is in myView1
    PApplet.runSketch(new String[]{"2"}, myView2); // run the sketch that is in myView2
    PApplet.runSketch(new String[]{"3"}, myView3); // run the sketch that is in myView3

    myModel = new Model(this); // create a new Model object (passing it this controller)
    myView1.setController(this);
    myView3.setController(this);
    myView1.setTreeMapChart(myModel.getTreeMapChart());
  }

  // getters
  public View1 getView1() {
    return this.myView1;
  }

  public View2 getView2() {
    return this.myView2;
  }

  public View3 getView3() {
    return this.myView3;
  }

  public void createView2RadialTSChart(String pStockSymbol) {
    myView2.setController(this);
    myView2.setRadialChart(myModel.getRadialTSChart(pStockSymbol));
  }

  public void createView3DayChart(PApplet p, String pStockSymbol, String pDate) {
    myView3.setController(this);
    myView3.setDayChart(myModel.getDayChart(p, pStockSymbol, pDate));
  }

  public String getRadialTSChartStockSymbol() {
    return myModel.getRadialTSChartStockSymbol();
  }

  public String getCollisionDate() {
    return myModel.getCollisionDate();
  }

  public boolean getIsValidCollisionDate() {
    return myModel.getIsValidCollisionDate();
  }
}