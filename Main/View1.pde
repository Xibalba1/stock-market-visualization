class View1 extends PApplet {

  TreeMapChart myTreeMapChart;
  Controller myController;
  boolean isTreeMapSet;
  float myMouseX;
  float myMouseY;
  String stockSymbol;

  public void settings() {
    this.size(800, 600);
    this.isTreeMapSet = false;
  }

  public void setup() {
  }

  public void draw() {
    background(255);
    if (this.isTreeMapSet) {
      myTreeMapChart.drawTreeMap();
      TreeMapNode collisionTreeMapNode = myTreeMapChart.treeMapNodeCollision(mouseX, mouseY);
      if (collisionTreeMapNode != null) {
        drawCollision(collisionTreeMapNode);
      }
    }
  }

  // setters
  public void setController(Controller pController) {
    this.myController = pController;
  }

  public void setTreeMapChart(TreeMapChart pTreeMapChart) {
    this.myTreeMapChart = pTreeMapChart;
    this.isTreeMapSet = true;
  }

  private void drawCollision(TreeMapNode pThisNode) {
    java.awt.geom.Rectangle2D myRect = pThisNode.getRectangle();
    FloatDict companyMarketCap = this.myTreeMapChart.getCompanyMarketCapDict();
    FloatDict company52WeekChange = this.myTreeMapChart.getCompany52WeekChangeDict();
    StringDict companyIndustry = this.myTreeMapChart.getCompanyIndustryDict();
    StringDict companyName = this.myTreeMapChart.getCompanyNameDict();
    float rH = (float)myRect.getHeight();
    float rW = (float)myRect.getWidth();
    float rX = (float)myRect.getX();
    float rY = (float)myRect.getY();
    String pNodeStockSymbol = pThisNode.getLabel();
    String pCompanyMarketCap = "Market Cap: $" + nfc(companyMarketCap.get(pNodeStockSymbol), 0);
    String pCompanyWeek52Change = "52 week price Δ: " + nfc(company52WeekChange.get(pNodeStockSymbol), 2);
    String pCompanyIndustry = companyIndustry.get(pNodeStockSymbol); 
    String pCompanyName = companyName.get(pNodeStockSymbol);
    fill(#c6ebff); // highlighted tile bg color
    rect(rX, rY, rW, rH); // draw the rect (tile)
    fill(0); // text color
    textAlign(CENTER, CENTER); // center text
    float textYAnchor = rY + (rH / 4);
    textSize(12); // text size
    text(pNodeStockSymbol, rX + (rW/2), textYAnchor); // draw stock symbol on top of tile
    text(pCompanyName, rX + (rW/2), textYAnchor + 16); // draw stock co name on top of tile
    text(pCompanyIndustry, rX + (rW/2), textYAnchor + 32); // draw industry text
    text(pCompanyMarketCap, rX + (rW/2), textYAnchor + 48); // draw market cap text
    text(pCompanyWeek52Change, rX + (rW/2), textYAnchor + 64);  // draw 
    noFill();
  }

  public void mouseClicked() {
    if (isTreeMapSet) {
      TreeMapNode collisionTreeMapNode = myTreeMapChart.treeMapNodeCollision(mouseX, mouseY);
      if (collisionTreeMapNode != null) {
        this.setStockSymbol(collisionTreeMapNode.getLabel());
        println("Loading 1y radial chart for " + this.stockSymbol + ".");
        myController.createView2RadialTSChart(this.stockSymbol);
      }
    }
  }

  public String getStockSymbol() {
    return this.stockSymbol;
  }

  public void setStockSymbol(String pStockSymbol) {
    this.stockSymbol = pStockSymbol;
  }
}