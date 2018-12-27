class TimeSeriesKeyRect {
  // data
  private float rx, ry, rw, rh;

  // constructor
  TimeSeriesKeyRect() {
    // do nothing
  }

  TimeSeriesKeyRect(float pRX, float pRY, float pRW, float pRH) {
    this.rx = pRX;
    this.ry = pRY;
    this.rw = pRW;
    this.rh = pRH;
  }

  // methods
  float getRX() {
    return this.rx;
  }

  float getRY() {
    return this.ry;
  }

  float getRW() {
    return this.rw;
  }

  float getRH() {
    return this.rh;
  }

  void drawTimeSeriesKeyRect(PApplet p) {
    p.rect(this.rx, this.ry, this.rw, this.rh);
  }
}