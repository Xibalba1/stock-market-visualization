import org.gicentre.utils.colour.*; // colors needed by treemappa //<>//

class TreeMapChart {

  // fields
  private final int SYMBOL_COUNT = 502;//502 symbols in the S&P 500 as of 2018-12-26;
  private final String CSV_FILE_NAME = "<YOUR_ABS_PATH_HERE>/data/sp500-treemap-data.csv";
  private final String TM_FILE_TYPE = "csvCompact";

  PTreeMappa treeMap;
  TreeMapNode rootNode;
  TreeMapNode[] allNodes;
  TreeMapPanel tmPanel;
  Table companyDataTable;
  FloatDict companyMarketCap = new FloatDict();
  FloatDict company52WeekChange = new FloatDict();
  StringDict companyIndustry = new StringDict();
  StringDict companyName = new StringDict();
  PFont arialBoldFont = createFont("Arial-BoldMT", 12);
  PFont arialPlain = createFont("ArialMT", 12);

  // constructor
  TreeMapChart() {
    // default cstr
  }

  TreeMapChart(PTreeMappa pTreeMappa, CompanyData pCompanyData) {
    this.treeMap = pTreeMappa;  // Create an empty treemap.
    this.treeMap.readData(CSV_FILE_NAME, TM_FILE_TYPE); // creates the treemap
    this.tmPanel = this.treeMap.getTreeMapPanel();
    this.allNodes = getLeafNodeArray();
    this.companyDataTable = pCompanyData.getCompanyDataTable();
    this.initializeCompanyStats(this.companyDataTable);
  }

  void formatTreeMap() {
    ColourTable myCTable = new ColourTable();
    myCTable.addContinuousColourRule(1, 186, 255, 188);
    myCTable.addContinuousColourRule(0, 255, 186, 186);
    this.tmPanel.setShowBranchLabels(true);
    this.tmPanel.setAllowVerticalLabels(false);
    this.tmPanel.setBranchTextAlignment(LEFT, TOP);
    this.tmPanel.setLeafTextAlignment(CENTER, CENTER);
    this.tmPanel.setBranchMaxTextSize(0, 80);
    this.tmPanel.setBranchMaxTextSize(1, 30);
    this.tmPanel.setLeafMaxTextSize(12);
    this.tmPanel.setBranchTextColours(color(100, 100, 100, 100));
    this.tmPanel.setLeafTextColour(0);
    this.tmPanel.setColourTable(myCTable);
    this.tmPanel.setBorderColour(color(0, 0, 0));

    // required after above changes to TreeMapPanel
    this.tmPanel.updateLayout();
    this.tmPanel.updateImage();
  }

  public void drawTreeMap() {
    this.formatTreeMap();
    this.treeMap.draw();
  }

  private TreeMapNode[] getLeafNodeArray() {
    TreeMapNode[] pAllNodes;
    pAllNodes = new TreeMapNode[this.SYMBOL_COUNT];
    this.rootNode = this.treeMap.getTreeMappa().getRoot();
    int addedNodeCount = 0;
    for (java.util.Iterator<TreeMapNode> i = this.rootNode.iterator(); i.hasNext(); ) {
      TreeMapNode aTMN = i.next();
      if (aTMN.getLevel() == 3) {
        pAllNodes[addedNodeCount] = aTMN;
        addedNodeCount ++;
      }
    }
    return pAllNodes;
  }

  private void initializeCompanyStats(Table pCompanyData) {
    for (TableRow row : pCompanyData.rows()) {

      String pStockSymbol = row.getString("symbol");
      float pMarketCap = row.getFloat("marketcap");
      float pWeek52Change = row.getFloat("week52change");
      String pCompanyIndustry = row.getString("industry");
      String pCompanyName = row.getString("companyName");

      this.companyMarketCap.set(pStockSymbol, pMarketCap);
      this.company52WeekChange.set(pStockSymbol, pWeek52Change);
      this.companyIndustry.set(pStockSymbol, pCompanyIndustry);
      this.companyName.set(pStockSymbol, pCompanyName);
    }
  }

  TreeMapNode treeMapNodeCollision(float pMouseX, float pMouseY) {
    TreeMapNode pCollisionNode = null; 
    for (int i = 0; i<this.allNodes.length; i++) {
      TreeMapNode thisNode = this.allNodes[i];
      java.awt.geom.Rectangle2D myRect = thisNode.getRectangle();
      float rh = (float)myRect.getHeight();
      float rw = (float)myRect.getWidth();
      float rx = (float)myRect.getX();
      float ry = (float)myRect.getY();
      if (pMouseX >= rx &&        // right of the left edge AND
        pMouseX <= rx + rw &&   // left of the right edge AND
        pMouseY >= ry &&        // below the top AND
        pMouseY <= ry + rh) {   // above the bottom
        pCollisionNode = thisNode;
      }
    }
    return pCollisionNode;
  }
  public FloatDict getCompanyMarketCapDict() {
    return this.companyMarketCap;
  }
  public FloatDict getCompany52WeekChangeDict() {
    return this.company52WeekChange;
  }
  public StringDict getCompanyIndustryDict() {
    return this.companyIndustry;
  }
  public StringDict getCompanyNameDict() {
    return this.companyName;
  }
}