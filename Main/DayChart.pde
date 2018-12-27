class DayChart {

  // data
  private String COMPANY_URL = "https://api.iextrading.com/1.0/stock/";
  private String COMPANY_QUERY = "/company";
  private float x1, y1, x2, y2; // corners of chart
  private Table chartData; // data for chart
  private String stockSymbol; // stock symbol of data
  private String companyName; // name of company of stock symbol
  private String chartDate;

  // constructors
  public DayChart() {
    // do nothing
  }

  public DayChart(PApplet p, Table pChartData) {

    // line plot data
    this.chartData = pChartData; //<>//

    // plot area
    float chartMargin = 65;
    this.x1 = chartMargin;
    this.y1 = chartMargin;
    this.x2 = p.width - chartMargin;
    this.y2 = p.height - chartMargin;

    // current stock symbol
    this.stockSymbol = pChartData.getRow(0).getString("symbol");
    this.companyName = getCompanyName(stockSymbol);
    this.chartDate = chartData.getRow(0).getString("year") + "-" + chartData.getRow(0).getString("month") + "-" + chartData.getRow(0).getString("day");
  }

  // methods
  public void drawChart(PApplet p) {

    // draw chart background
    p.fill(color(230, 230, 230, 125));
    p.stroke(1);
    p.rect(this.x1, this.y1, this.x2-this.x1, this.y2-this.y1);
    p.noStroke();

    // draw chart title/subtitle/attribution line
    drawTitles(p, this.stockSymbol);

    // draw y-axis:  labels / ticks / title
    drawYAxis(p, this.chartData);
    drawY2Axis(p, this.chartData);

    // draw x-axis :  labels / ticks / title
    drawXAxis(p, this.chartData);

    // draw chart data (line)
    drawData(p, this.chartData);

    // draw an ellipse corresponding to the date where the mouse is
    drawXCollision(p, this.chartData);
  }


  float[] getYMinMax(Table pChartData) {
    // iterate over pChartData to determine x/y axis min/max vals
    TableRow row = pChartData.getRow(0);
    float pYMin = row.getFloat("average");
    float pYMax = row.getFloat("average");
    float pY2Min = row.getFloat("volume");
    float pY2Max = row.getFloat("volume");

    for (TableRow thisRow : pChartData.rows()) {
      float pAvgPrice = thisRow.getFloat("average");
      float pVolume = thisRow.getFloat("volume");
      if (pAvgPrice > pYMax) {
        pYMax = pAvgPrice;
      }
      if (pAvgPrice < pYMin) {
        pYMin = pAvgPrice;
      }
      if (pVolume > pY2Max) {
        pY2Max = pVolume;
      }
      if (pVolume < pY2Min) {
        pY2Min = pVolume;
      }
    }

    float[] YMinMax = {pYMin, pYMax, pY2Min, pY2Max};
    return YMinMax;
  }

  void drawXAxis(PApplet p, Table pChartData) {
    // draw the X-axis

    p.fill(0);
    p.textSize(10);

    int maxRowIdx = pChartData.getRowCount()-1;
    int[] rowIdx = new int[5];
    String timeLabel;
    int labelIncrement = int(maxRowIdx / 4);

    rowIdx[0] = 0;
    rowIdx[1] = labelIncrement;
    rowIdx[2] = labelIncrement * 2;
    rowIdx[3] = labelIncrement * 3;
    rowIdx[4] = maxRowIdx;

    for (int i = 0; i < rowIdx.length; i++) {
      timeLabel = pChartData.getRow(rowIdx[i]).getString("label");
      float x = map(rowIdx[i], maxRowIdx, 0, this.x2, this.x1);
      p.text(timeLabel, x, p.height-40);
      p.stroke(0);
      p.line(x, this.y2, x, this.y2+5);
      p.noStroke();
    }
  }

  void drawYAxis(PApplet p, Table pChartData) {

    // y-axis min and max values
    float yMin; // y-axis min value
    float yMax; // y-axis max value
    float[] yMinMax = getYMinMax(pChartData);
    yMin = yMinMax[0];
    yMax = yMinMax[1];

    // draw ticks and tick labels
    p.fill(0);
    p.textSize(10);
    p.textAlign(RIGHT);
    p.stroke(0);
    float yIncrement = (yMax - yMin) / 10;
    for (float i= yMin; i <= yMax; i += yIncrement) {
      float y = map(i, yMin, yMax, this.y2, this.y1);
      p.textAlign(RIGHT, CENTER);
      p.text(String.format("%.2f", i), this.x1-10, y);
      p.line(this.x1, y, this.x1-5, y);
    }

    // draw y-axis title
    p.textSize(15);
    p.pushMatrix();
    p.translate(this.x1-45, (this.y2-this.y1) / 2 + this.y1);
    p.rotate(-PI/2);
    p.textAlign(CENTER, BOTTOM);
    p.text("Price ($USD)", 0, 0);
    p.popMatrix();
  }  

  void drawY2Axis(PApplet p, Table pChartData) {

    // y-axis min and max values
    float y2Min; // y-axis min value
    float y2Max; // y-axis max value
    float[] y2MinMax = getYMinMax(pChartData);
    y2Min = y2MinMax[2];
    y2Max = y2MinMax[3];

    // draw ticks and tick labels
    p.fill(0);
    p.textSize(10);
    p.textAlign(RIGHT);
    p.stroke(0);
    float yIncrement = (y2Max - y2Min) / 10;
    for (float i= y2Min; i <= y2Max; i += yIncrement) {
      float y = map(i, y2Min, y2Max, this.y2, this.y1);
      p.textAlign(LEFT, CENTER);
      p.text(String.format("%.0f", i), this.x2+10, y);
      p.line(this.x2, y, this.x2+5, y);
    }

    // draw y2-axis title
    p.textSize(15);
    p.pushMatrix();
    p.translate(p.width-8, (this.y2-this.y1) / 2 + this.y1);
    p.rotate(-PI/2);
    p.textAlign(CENTER, BOTTOM);
    p.text("Volume", 0, 0);
    p.popMatrix();
  }  

  void drawTitles(PApplet p, String pStockSymbol) {

    // Chart title
    p.fill(0);
    p.textSize(18);
    p.textAlign(LEFT);
    p.text(this.companyName, this.x1, this.y1-27);

    // Chart subtitle
    p.textSize(10);
    p.text("Stock Symbol: " + pStockSymbol, this.x1, this.y1 - 15);
    p.text("Date: " + this.chartDate, this.x1, this.y1-5);

    // Data attribution
    p.textSize(10);
    p.textAlign(RIGHT, BOTTOM);
    p.text("Data provided for free by IEX.", p.width-1, p.height-1);
  }

  void drawData(PApplet p, Table pChartData) {

    // some drawing settings
    p.stroke(0);
    p.noFill();
    p.ellipseMode(CENTER);

    // y-axis min and max values
    float yMin; // y-axis min value
    float yMax; // y-axis max value
    float y2Min;
    float y2Max;
    float[] yMinMax = getYMinMax(pChartData);
    yMin = yMinMax[0];
    yMax = yMinMax[1];
    y2Min = yMinMax[2];
    y2Max = yMinMax[3];

    // draw vertical bars (volume)
    int dataRowCount = pChartData.getRowCount();
    int i = 0;
    for (TableRow row : pChartData.rows()) {
      int pVolume = row.getInt("volume");
      float x = map(i, 0, dataRowCount, this.x1, this.x2);
      float w = 2;
      float h = map(pVolume, y2Min, y2Max, 0, this.y2-this.y1);
      float y = y2-h;
      p.fill(color(233, 245, 255));
      p.rect(x, y, w, h);
      p.noFill();
      i++;
    }
    
    // draw the line (stock price)
    p.strokeWeight(2);
    p.beginShape();
    i =  0;
    for (TableRow row : pChartData.rows()) {
      float x = map(i, 0, dataRowCount, this.x1, this.x2);
      float y = map(row.getFloat("average"), yMin, yMax, this.y2, this.y1);
      i++;
      p.vertex(x, y);
      p.ellipse(x, y, 3, 3);
    }
    p.endShape();
    p.strokeWeight(1);
  }

  void drawXCollision(PApplet p, Table pChartData) {

    // y-axis min and max values
    float yMin; // y-axis min value
    float yMax; // y-axis max value
    float[] yMinMax = getYMinMax(pChartData);
    yMin = yMinMax[0];
    yMax = yMinMax[1];
    float openingPrice = pChartData.getRow(0).getFloat("average");

    // search for collision
    int i =  0;
    int dataRowCount = pChartData.getRowCount();
    for (TableRow row : pChartData.rows()) {
      float x = map(i, 0, dataRowCount, this.x1, this.x2);
      float y = map(row.getFloat("average"), yMin, yMax, this.y2, this.y1);

      // draw ellipse and interect lines when collision found
      if (p.mouseX == round(x)) {

        // display values
        String time = row.getString("label");          
        String dateString = "Time: " + time;
        float avgPrice = row.getFloat("average"); // average price and close price are used synonymously
        String closingPrice = "Average Price: $" + str(avgPrice);
        String volume = "Volume: " + str(row.getInt("volume"));

        if (avgPrice > openingPrice) {
          p.fill(#89ff87); // a nice green
          p.stroke(#89ff87);
        } 
        if (avgPrice < openingPrice) {
          p.fill(#ff7777); // a nice red
          p.stroke(#ff7777);
        } 
        if (avgPrice == openingPrice) {
          p.fill(#f3ff87); // a nice yellow
          p.stroke(#f3ff87);
        } 
        p.line(x, this.y1, x, this.y2);
        p.line(this.x1, y, this.x2, y);
        p.ellipse(x, y, 10, 10);
        p.noStroke();
        p.fill(0);
        p.textAlign(RIGHT);
        p.textSize(18);
        p.text(dateString, this.x2-5, this.y1-45);
        p.text(closingPrice, this.x2-5, this.y1-25);
        p.text(volume, this.x2-5, this.y1-5);
        p.stroke(10);
        p.textAlign(LEFT);
        break;
      }
      i++;
    }
  }

  // getters/setters

  void setChartData(Table pChartData) {
    this.chartData = pChartData;
    this.stockSymbol = pChartData.getRow(0).getString("symbol");
    this.companyName = getCompanyName(this.stockSymbol);
  }

  String getCompanyName(String pStockSymbol) {
    String pCompanyName;
    JSONObject pJSONCompanyData = loadJSONObject(COMPANY_URL + pStockSymbol + COMPANY_QUERY);
    pCompanyName = pJSONCompanyData.getString("companyName");
    return pCompanyName;
  }
}