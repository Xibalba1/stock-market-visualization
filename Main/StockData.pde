class StockData {

  // attributes
  private final String CHART_URL = "https://api.iextrading.com/1.0/stock/";
  private final String CHART_QUERY = "/chart/1y";
  private String[] stockSymbol;
  private Table chartDataTable;
  private String currentStockSymbol;
  private float closePriceMin;
  private float closePriceMax;

  // constructors
  public StockData() {
    this.currentStockSymbol = "XOM"; // default stock symbol
    this.chartDataTable = retrieveChartDataTable(currentStockSymbol);
    this.calcPriceMinMax();
  }

  public StockData(String pStockSymbol) {
    this.currentStockSymbol = pStockSymbol;
    this.chartDataTable = retrieveChartDataTable(currentStockSymbol);
    this.calcPriceMinMax();
  }

  // methods
  String[] loadSymbols() {
    String[] pSymbols;
    String[] pLines;
    pLines = loadStrings("sp-500-symbols.txt");
    pSymbols = new String[pLines.length];
    for (int i = 0; i < pLines.length; i++) {
      pSymbols[i] = trim(pLines[i]).toUpperCase();
    }
    return pSymbols;
  }

  Table retrieveChartDataTable(String pStockSymbol) {
    Table pChartDataTable = new Table();
    JSONArray pJSONChartData = loadJSONArray(CHART_URL + pStockSymbol + CHART_QUERY);
    pChartDataTable.addColumn("year");
    pChartDataTable.addColumn("month");
    pChartDataTable.addColumn("monthName");
    pChartDataTable.addColumn("day");
    pChartDataTable.addColumn("closePrice");
    pChartDataTable.addColumn("symbol");
    pChartDataTable.addColumn("monthLabel");
    pChartDataTable.addColumn("dateLabel");

    for (int i = 0; i < pJSONChartData.size(); i++) {
      JSONObject dayDataObject = (JSONObject)pJSONChartData.get(i);
      float priceClose = dayDataObject.getFloat("close");
      String priceDate = dayDataObject.getString("date");
      int priceDay = int(priceDate.substring(8, 10));
      int priceMonth = int(priceDate.substring(5, 7));
      String priceMonthName = "";
      int priceYear = int(priceDate.substring(0, 4));
      switch(priceMonth) {
      case 1: 
        priceMonthName ="Jan"; 
        break;
      case 2: 
        priceMonthName ="Feb"; 
        break;
      case 3: 
        priceMonthName ="Mar"; 
        break;
      case 4: 
        priceMonthName ="Apr"; 
        break;
      case 5: 
        priceMonthName ="May"; 
        break;
      case 6: 
        priceMonthName ="Jun"; 
        break;
      case 7: 
        priceMonthName ="Jul"; 
        break;
      case 8: 
        priceMonthName ="Aug"; 
        break;
      case 9: 
        priceMonthName ="Sep"; 
        break;
      case 10: 
        priceMonthName ="Oct"; 
        break;
      case 11: 
        priceMonthName ="Nov"; 
        break;
      case 12: 
        priceMonthName ="Dec"; 
        break;
      default:
        priceMonthName = "UNK";
        break;
      }
      String pMonthLabelSubStr = "0" + str(priceMonth);
      String pDayLabelSubStr = "0" + str(priceDay);
      pMonthLabelSubStr = pMonthLabelSubStr.substring(pMonthLabelSubStr.length()-2,pMonthLabelSubStr.length());
      pDayLabelSubStr = pDayLabelSubStr.substring(pDayLabelSubStr.length()-2,pDayLabelSubStr.length());
      TableRow newRow = pChartDataTable.addRow();
      newRow.setString("symbol", pStockSymbol);
      newRow.setInt("year", priceYear);
      newRow.setInt("month", priceMonth);
      newRow.setString("monthName", priceMonthName);
      newRow.setInt("day", priceDay);
      newRow.setFloat("closePrice", priceClose);
      newRow.setString("dateLabel", str(priceYear) + pMonthLabelSubStr + pDayLabelSubStr);
    }
    return pChartDataTable;
  }

  // getters
  Table getChartDataTable() {
    return chartDataTable;
  }


  void setStockSymbol(String pStockSymbol) {
    if (isStockSymbolValid(pStockSymbol)) {
      this.currentStockSymbol = pStockSymbol;
      this.chartDataTable = retrieveChartDataTable(currentStockSymbol);
    }
  }


  boolean isStockSymbolValid(String pStockSymbol) {
    pStockSymbol = trim(pStockSymbol).toUpperCase();
    for (int i = 0; i < this.stockSymbol.length; i++) {
      if (pStockSymbol.equals(stockSymbol[i])) {
        return true;
      }
    }
    println("WARNING:  Invalid stock symbol:", pStockSymbol);
    return false;
  }

  String getNextStockSymbol() {
    String pNextStockSymbol = "";
    int stockSymbolCount = stockSymbol.length;
    for (int i = 0; i < stockSymbolCount; i++) {
      String thisStockSymbol = stockSymbol[i];
      thisStockSymbol = trim(thisStockSymbol).toUpperCase();
      if (thisStockSymbol.equals(this.currentStockSymbol)) {
        if (i < stockSymbolCount -1) {
          pNextStockSymbol = stockSymbol[i+1];
          break;
        } else {
          pNextStockSymbol = stockSymbol[0];
          break;
        }
      }
    }
    return pNextStockSymbol;
  }

  String getCurrentStockSymbol() {
    return this.currentStockSymbol;
  }

  private void calcPriceMinMax() {
    float pPriceMin = chartDataTable.getRow(0).getFloat("closePrice");
    float pPriceMax = chartDataTable.getRow(0).getFloat("closePrice");
    for (TableRow row : chartDataTable.rows()) {
      float pThisRowPrice = row.getFloat("closePrice");
      if (pThisRowPrice < pPriceMin) {
        pPriceMin = pThisRowPrice;
      }
      if (pThisRowPrice > pPriceMax) {
        pPriceMax = pThisRowPrice;
      }
    }
    this.closePriceMin = pPriceMin;
    this.closePriceMax = pPriceMax;
  }

  float getClosePriceMax() {
    return this.closePriceMax;
  }

  public float getClosePriceMin() {
    return this.closePriceMin;
  }
}