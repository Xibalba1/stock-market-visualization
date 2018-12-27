import org.gicentre.treemappa.*;  //<>//

class Model {
  CompanyData companyData;
  PTreeMappa pTreeMappa;
  Controller myController;
  TreeMapChart myTreeMapChart;
  RadialTSChart myRadialTSChart;
  DayStockData myDayStockData;
  DayChart myDayChart;



  public Model(Controller pController) {
    myController = pController;
    this.companyData = new CompanyData(); // DEBUG mode
    this.companyData.writeCSVTreeFormat();
    this.pTreeMappa = new PTreeMappa(myController.getView1());
    this.myTreeMapChart = new TreeMapChart(this.pTreeMappa, companyData);
  }

  public TreeMapChart getTreeMapChart() {
    return this.myTreeMapChart;
  }

  public RadialTSChart getRadialTSChart(String pStockSymbol) {
    this.myRadialTSChart = new RadialTSChart(myController.getView2(), pStockSymbol, this.getCompanyDataRow(pStockSymbol));
    return this.myRadialTSChart;
  }

  public TableRow getCompanyDataRow(String pStockSymbol) {
    return companyData.getCompanyRow(pStockSymbol);
  }

  public DayChart getDayChart(PApplet p, String pStockSymbol, String pDate) {
    this.myDayStockData = new DayStockData(pDate, pStockSymbol);
    this.myDayChart = new DayChart(p, myDayStockData.getChartDataTable()); //<>//
    return this.myDayChart;
  }

  public String getRadialTSChartStockSymbol() {
    return this.myRadialTSChart.getStockSymbol();
  }

  public String getCollisionDate() {
    return this.myRadialTSChart.getCollisionDate();
  }
  
  public boolean getIsValidCollisionDate() {
    return this.myRadialTSChart.getIsValidCollisionDate();
  }
}