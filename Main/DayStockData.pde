class DayStockData { //<>// //<>// //<>//
  // data
  final private String CHART_URL = "https://api.iextrading.com/1.0/stock/";
  final private String CHART_QUERY = "/chart/date/";
  private String dayQuery;
  private String stockSymbol;
  private Table chartDataTable;

  // constructor
  DayStockData() {
    this.stockSymbol = "TSLA";
    this.dayQuery = "20180129";
    this.chartDataTable = retrieveChartDataTable(this.dayQuery, this.stockSymbol);
  }

  DayStockData(String pDayQuery, String pStockSymbol) {
    this.dayQuery = pDayQuery;
    this.stockSymbol = pStockSymbol;
    this.chartDataTable = retrieveChartDataTable(this.dayQuery, this.stockSymbol);
  }

  // methods
  Table retrieveChartDataTable(String pDayQuery, String pStockSymbol) {
    Table pChartDataTable = new Table();
    JSONArray pJSONChartData = loadJSONArray(CHART_URL + pStockSymbol + CHART_QUERY + pDayQuery);
    pChartDataTable.addColumn("symbol");
    pChartDataTable.addColumn("date");
    pChartDataTable.addColumn("year");
    pChartDataTable.addColumn("month");
    pChartDataTable.addColumn("day");
    pChartDataTable.addColumn("minute");
    pChartDataTable.addColumn("label");
    pChartDataTable.addColumn("average"); // this is the stock price
    pChartDataTable.addColumn("volume");
    pChartDataTable.addColumn("notional");
    pChartDataTable.addColumn("numberOfTrades");

    for (int i = 0; i < pJSONChartData.size(); i++) {
      JSONObject dayDataObject = (JSONObject)pJSONChartData.get(i);
      float priceAverage = dayDataObject.getFloat("average");
      if (priceAverage == 0) {
        continue;
      }
      String priceDate = dayDataObject.getString("date");
      String priceDay = priceDate.substring(6, 8);
      String priceMonth = priceDate.substring(4, 6);
      String priceYear = priceDate.substring(0, 4);
      String priceMinute = dayDataObject.getString("minute");
      String priceLabel = dayDataObject.getString("label");
      float priceVolume = dayDataObject.getFloat("volume");
      float priceNotional = dayDataObject.getFloat("notional");
      int priceNumberOfTrades = dayDataObject.getInt("numberOfTrades");


      TableRow newRow = pChartDataTable.addRow();
      newRow.setString("symbol", this.stockSymbol);
      newRow.setFloat("average", priceAverage);
      newRow.setString("date", priceDate);
      newRow.setString("year", priceYear);
      newRow.setString("month", priceMonth);
      newRow.setString("day", priceDay);
      newRow.setString("minute", priceMinute);
      newRow.setString("label", priceLabel);
      newRow.setFloat("volume", priceVolume);
      newRow.setFloat("notional", priceNotional);
      newRow.setInt("numberOfTrades", priceNumberOfTrades);
    }
    return pChartDataTable;
  }

  // getters
  String getStockSymbol() {
    return this.stockSymbol;
  }


  Table getChartDataTable() {
    return this.chartDataTable;
  }
}