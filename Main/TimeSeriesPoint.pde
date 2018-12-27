class TimeSeriesPoint {
  // data
  private float x; // x-coordinate
  private float y; // y-coordinate
  private float w; // width
  private float h; // height
  private float rotAngle;
  private float closePrice; // the closePrice
  private color pointColor;
  private TimeSeriesKeyRect myTSKR;

  // constructors
  TimeSeriesPoint() {
    this.x = 0;
    this.y = 0;
    this.w = 0;
    this.h = 0;
    this.rotAngle = 0;
  }

  TimeSeriesPoint(float pX, float pY, float pW, float pH, float pRotAngle, float pClosePrice, color pPointColor) {
    this.x = pX;
    this.y = pY;
    this.w = pW;
    this.h = pH;
    this.rotAngle = pRotAngle;
    this.closePrice = pClosePrice;
    this.pointColor = pPointColor;
  }

  // methods
  void setTimeSeriesKeyRect(float pRX, float pRY, float pRW, float pRH) {
    this.myTSKR = new TimeSeriesKeyRect(pRX, pRY, pRW, pRH);
  }

  float getX() {
    return this.x;
  }

  float getY() {
    return this.y;
  }

  float getWidth() {
    return this.w;
  }

  float getHeight() {
    return this.h;
  }

  float getRotAngle() {
    return this.rotAngle;
  }

  float getClosePrice() {
    return this.closePrice;
  }

  color getColor() {
    return this.pointColor;
  }

  void drawTimeSeriesKeyRect(PApplet p) {
    this.myTSKR.drawTimeSeriesKeyRect(p);
  }

  TimeSeriesKeyRect getTSKeyRect() {
    return myTSKR;
  }
}