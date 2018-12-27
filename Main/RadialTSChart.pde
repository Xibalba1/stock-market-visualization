class RadialTSChart {
  // data
  private String stockSymbol;
  private StockData stockData;
  private TimeSeriesPoint[] myTSPoint;
  private Table chartDataTable;
  private float circleDiameter;
  private TimeSeriesKey myTSK;
  private float sketchHeight;
  private float sketchWidth;
  private TableRow companyDataRow;
  private boolean isCollidingNow;
  private String collisionDate;
  private boolean isValidCollisionDate;

  // constructors
  RadialTSChart() {
    this.isCollidingNow = false;
    this.stockData = new StockData();
    this.chartDataTable = this.stockData.getChartDataTable();
    myTSK = new TimeSeriesKey();
    createTimeSeries();
    myTSK.setTimeSeriesKeyLabels();
  }

  RadialTSChart(PApplet p, String pStockSymbol, TableRow pCompanyDataRow) {
    this.isCollidingNow = false;
    this.stockSymbol = pStockSymbol;
    this.companyDataRow = pCompanyDataRow;
    this.stockData = new StockData(this.stockSymbol);
    this.chartDataTable = this.stockData.getChartDataTable();
    this.sketchHeight = p.height;
    this.sketchWidth = p.width;
    this.circleDiameter = this.sketchHeight/2;
    myTSK = new TimeSeriesKey(p, this.chartDataTable);
    createTimeSeries();
    myTSK.setTimeSeriesKeyLabels();
  }

  //methods
  public void drawChart(PApplet p) {
    p.background(255);
    //float circleDiameter = height/2;
    this.drawCircle(p, this.circleDiameter);  // can this be DEPRECATED?
    this.myTSK.drawTimeSeriesKey(p);
    this.drawTimeSeries(p);
    this.drawDashFixedText(p);
  }

  private void drawCircle(PApplet p, float pCircleDiameter) {
    p.ellipseMode(CENTER);
    p.noFill();
    p.noStroke();
    p.ellipse(this.sketchWidth/2, this.sketchHeight/2, pCircleDiameter, pCircleDiameter);
  }

  private void drawTimeSeries(PApplet p) {
    float rx, ry, rw, rh, rotAngle = 0;
    color rectColor;
    this.isCollidingNow = false;
    this.collisionDate = "";
    this.isValidCollisionDate = false;

    for (int i = 0; i < myTSPoint.length; i++) {

      rx = myTSPoint[i].getX();
      ry = myTSPoint[i].getY();
      rw = myTSPoint[i].getWidth();
      rh = myTSPoint[i].getHeight();
      rectColor = myTSPoint[i].getColor();
      rotAngle += myTSPoint[i].getRotAngle();
      p.rectMode(CENTER);

      //  draw time series key rectangles  
      p.pushMatrix();
      p.translate(0, 30);
      p.stroke(.01);
      if (this.isCollision(p, myTSPoint[i].getTSKeyRect())) {
        this.isCollidingNow = true;
        this.collisionDate = this.chartDataTable.getRow(i).getString("dateLabel");
        if (i > myTSPoint.length-31) { // current IEX API only supports day charts within last 30 days of current day
          this.isValidCollisionDate = true;
        }
        p.pushMatrix();
        p.translate(this.sketchWidth/2, this.sketchHeight/2);
        p.fill(rectColor);
        p.textAlign(CENTER);
        drawDynamicText(p, i);
        p.textAlign(LEFT);
        p.popMatrix();
        p.fill(#609dff); // a nice blue
      } else {
        p.fill(rectColor);
      }
      myTSPoint[i].drawTimeSeriesKeyRect(p);
      p.noStroke();
      p.popMatrix();

      // draw rectangles on circle perimeter
      p.pushMatrix();
      p.translate(this.sketchWidth/2, this.sketchHeight/2);
      p.rotate(rotAngle); // clockwise rotation
      p.rect(rx, ry, rw, rh);
      p.noFill();
      p.popMatrix();

      p.noStroke();
      p.rectMode(CORNER);
    }
  }

  private void drawDashFixedText(PApplet p) {
    String pCompanyName = this.companyDataRow.getString("companyName");
    p.pushMatrix();
    p.translate(this.sketchWidth/2, this.sketchHeight/2);
    p.stroke(255);
    p.textAlign(CENTER);
    p.textSize(50);
    p.fill(0);
    p.text(this.stockSymbol, 0, -50);
    p.textSize(25);
    p.text(pCompanyName, 0, -25);
    p.popMatrix();
    p.textAlign(LEFT);
    
    // Data attribution
    p.fill(0);
    p.textSize(10);
    p.textAlign(RIGHT, BOTTOM);
    p.text("Data provided for free by IEX.", p.width-1, p.height-1);
    p.textAlign(LEFT);
  }

  void createTimeSeries() {
    float pCircleDiameter = this.circleDiameter;
    float pClosePriceMax = this.stockData.getClosePriceMax();
    float pClosePriceMin = this.stockData.getClosePriceMin();
    float pFirstClosePrice = this.chartDataTable.getRow(0).getFloat("closePrice");
    int pTSLength = this.chartDataTable.getRowCount();
    myTSPoint = new TimeSeriesPoint[pTSLength];
    float pRotMagnitude = 2*PI/pTSLength;
    float pCircleRadius = pCircleDiameter/2;
    float pMaxYScale = (this.sketchWidth/2 - pCircleRadius) * .95;
    float rx, ry, rw, rh;
    rx = 0; // this will always be zero
    rw = PI * pCircleDiameter/pTSLength; // CIRCUMFERENCE / COUNT OF TIME SERIES POINTS
    color tspColor = color(0, 0, 0);
    PVector tsKeyStartPoint = myTSK.getStartPoint();
    PVector tsKeyEndPoint = myTSK.getEndPoint();

    for (int i = 0; i < pTSLength; i++) {
      TableRow thisRow = this.chartDataTable.getRow(i);
      float pCurrentClosePrice = thisRow.getFloat("closePrice");
      if (pCurrentClosePrice > pFirstClosePrice) {
        tspColor = color(66, 244, 80);
      }
      if (pCurrentClosePrice < pFirstClosePrice) {
        tspColor = color(244, 66, 98);
      }
      if (pCurrentClosePrice == pFirstClosePrice) {
        tspColor = color(198, 198, 190);
      }
      rh = map(pCurrentClosePrice, pClosePriceMin, pClosePriceMax, 0, pMaxYScale);
      ry = -1*(pCircleRadius + rh/2);

      myTSPoint[i] = new TimeSeriesPoint(rx, ry, rw, rh, pRotMagnitude, pCurrentClosePrice, tspColor);
      float tsKeyRectX = map(i, 0, pTSLength-1, tsKeyStartPoint.x, tsKeyEndPoint.x);
      float tsKeyRectY = (i % 2 ==0) ? 5:-5;
      float tsKeyRectW = 3;
      float tsKeyRectH = 10;
      myTSPoint[i].setTimeSeriesKeyRect(tsKeyRectX, tsKeyRectY, tsKeyRectW, tsKeyRectH);
    }
  }

  private boolean isCollision(PApplet p, TimeSeriesKeyRect pThisTSKeyRect) {
    boolean pIsCollision = false;
    float px = p.mouseX;
    float py = p.mouseY - 30; // to adjust for the translation, this is kind of hack-ey!
    float rx = pThisTSKeyRect.getRX();
    float ry = pThisTSKeyRect.getRY();
    float rw = pThisTSKeyRect.getRW();
    float rh = pThisTSKeyRect.getRH();
    if (px >= rx &&      // right of the left edge AND
      px <= rx + rw &&   // left of the right edge AND
      py >= ry &&        // below the top AND
      py <= ry + rh) {   // above the bottom
      pIsCollision = true;
    }
    return pIsCollision;
  }

  void drawDynamicText(PApplet p, int index) {
    TableRow pThisRow = chartDataTable.getRow(index);
    String pClosePrice = "$"+String.format("%.2f", pThisRow.getFloat("closePrice"));
    String pDay = "0" + str(pThisRow.getInt("day"));
    String pMonth = "0" + str(pThisRow.getInt("month"));
    String pYear = str(pThisRow.getInt("year"));
    pDay = pDay.substring(pDay.length()-2, pDay.length());
    pMonth = pMonth.substring(pMonth.length()-2, pMonth.length());
    String pDateString = pYear + "-" + pMonth + "-" + pDay; 

    p.textSize(50);
    p.text(pClosePrice, 0, 25);
    p.fill(0);
    p.textSize(25);
    p.text(pDateString, 0, -27);
  }

  public String getStockSymbol() {
    return this.stockSymbol;
  }

  public boolean getIsCollision() {
    return this.isCollidingNow;
  }

  public String getCollisionDate() {
    return this.collisionDate;
  }

  public boolean getIsValidCollisionDate() {
    return this.isValidCollisionDate;
  }
}