class TimeSeriesKey {
  //data
  private PVector start_point;
  private PVector end_point;
  private Table chartDataTable;
  private String[] timeSeriesKeyLabels;


  // constructors
  TimeSeriesKey() {
    // do nothing
  }

  TimeSeriesKey(PApplet p, Table pChartDataTable) {
    this.chartDataTable = pChartDataTable;
    this.start_point = new PVector(30, 30);
    this.end_point = new PVector(p.width-30, 30);
  }

  // methods
  void drawTimeSeriesKey(PApplet p) {
    p.stroke(0);
    p.fill(0);
    p.line(this.start_point.x-2, this.start_point.y+25, this.start_point.x-2, this.start_point.y-25); // start vertical line
    p.line(this.start_point.x, this.start_point.y, this.end_point.x, this.end_point.y); // horizontal line
    p.line(this.end_point.x+2, this.end_point.y+25, this.end_point.x+2, this.end_point.y-25); // end vertical line
    this.drawTimeSeriesKeyLabels(p);
  }

  void drawTimeSeriesKeyLabels(PApplet p) {
    for (int i = 0; i < this.timeSeriesKeyLabels.length; i++) {
      float x = map(i, 0, 3, start_point.x, end_point.x);
      float y = start_point.y + 35;
      p.textAlign(CENTER);
      p.textSize(12);
      p.text(timeSeriesKeyLabels[i], x, y);
      p.textAlign(LEFT);
    }
  }

  // getters
  public PVector getStartPoint() {
    return this.start_point;
  }

  PVector getEndPoint() {
    return this.end_point;
  }

  // setters
  void setTimeSeriesKeyLabels() {
    float tsLength = this.chartDataTable.getRowCount();
    int[] pTSKLabelIndices = new int[4];
    String[] pTSKLabels = new String[4];
    pTSKLabelIndices[0] = 0;
    pTSKLabelIndices[1] = int(tsLength / 3.0)-1;
    pTSKLabelIndices[2] = int((tsLength / 3.0)*2)-1;
    pTSKLabelIndices[3] = int(tsLength)-1;

    for (int i = 0; i < tsLength; i++) {
      for (int j = 0; j < 4; j++) {
        if (pTSKLabelIndices[j] == i) {
          TableRow thisRow = this.chartDataTable.getRow(i);
          String pMonthName = thisRow.getString("monthName");
          String pYear = str(thisRow.getInt("year"));
          pYear = "'" + pYear.substring(2, 4);
          pTSKLabels[j] = pMonthName + " " + pYear;
        }
      }
    }
    this.timeSeriesKeyLabels = pTSKLabels;
  }
}