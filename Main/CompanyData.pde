class CompanyData {

  // attributes
  private static final String IEX_URL = "https://api.iextrading.com/1.0/stock/";
  private static final String IEX_COMPANY_QUERY = "/company";
  private static final String IEX_COSTATS_QUERY = "/stats";
  private float totalMarketCap;
  private Table companyDataTable;
  private String[] stockSymbol;
  private boolean isDebugMode;

  // constructors
  CompanyData() {
    // the default constructor
    this.stockSymbol = loadSymbols();
    this.companyDataTable = loadData(this.stockSymbol);
    this.totalMarketCap = getTotalMarketCap();
  }

  CompanyData(boolean pIsDebugMode) {
    this.isDebugMode = pIsDebugMode;
    this.stockSymbol = loadSymbols();
    this.companyDataTable = loadData(this.stockSymbol);
    this.totalMarketCap = getTotalMarketCap();
  }

  // methods
  Table getCompanyDataTable() {
    return this.companyDataTable;
  }

  void writeCSVTreeFormat() {
    // compact csv format for TreeMappa:
    // Label, Size, Colour, x, y, Level0, Level1, Level2 etc.
    Table csvFormatTable = new Table();
    csvFormatTable.addColumn("#Label"); // hack-- pound sign causes treemappa to skip headers
    csvFormatTable.addColumn("Size");
    csvFormatTable.addColumn("Colour");
    csvFormatTable.addColumn("x");
    csvFormatTable.addColumn("y");
    csvFormatTable.addColumn("Level0");
    csvFormatTable.addColumn("Level1");
    for (TableRow row : this.companyDataTable.rows()) {
      String label = row.getString("symbol");
      String size = str(int(row.getFloat("marketcap") / this.totalMarketCap * 100000));
      String colorVal = str((row.getFloat("week52change")>0) ? 1 : 0);
      String x = "";
      String y = "";
      String level0 = "S&P 500";
      String level1 = row.getString("sector");
      TableRow newRow = csvFormatTable.addRow();
      // Label, Size, Colour, x, y, Level0, Level1, Level2 etc.
      newRow.setString("#Label", label);
      newRow.setString("Size", size);
      newRow.setString("Colour", colorVal);
      newRow.setString("x", x);
      newRow.setString("y", y);
      newRow.setString("Level0", level0);
      newRow.setString("Level1", level1);
    }
    saveTable(csvFormatTable, "data/sp500-treemap-data.csv");
  }


  float getTotalMarketCap() {
    float pTotalMarketCap = 0.0;
    for (TableRow row : this.companyDataTable.rows()) {
      pTotalMarketCap += row.getFloat("marketcap");
    }
    return pTotalMarketCap;
  }

  String[] loadSymbols() {
    String[] pLines;
    String[] pSymbols;
    pLines = loadStrings("sp-500-symbols.txt");
    pSymbols = new String[pLines.length];
    for (int i = 0; i < pLines.length; i++) {
      pSymbols[i] = trim(pLines[i]).toUpperCase();
    }
    return pSymbols;
  }

  Table loadData(String[] pStockSymbol) {
    int pCompanyCount;
    Table pCompanyData = new Table();
    if (this.isDebugMode) {
      pCompanyCount = 10;   
      println("DEBUG_MODE");
    } else {
      pCompanyCount = pStockSymbol.length;
    }

    pCompanyData.addColumn("symbol");
    pCompanyData.addColumn("companyName");
    pCompanyData.addColumn("exchange");
    pCompanyData.addColumn("industry");
    pCompanyData.addColumn("website");
    pCompanyData.addColumn("CEO");
    pCompanyData.addColumn("issueType");
    pCompanyData.addColumn("sector");
    pCompanyData.addColumn("marketcap");
    pCompanyData.addColumn("week52change");
    println("Begin:  load company data for treemap chart");
    for (int i = 0; i < pCompanyCount; i++) {
      String pCurrStockSymbol = pStockSymbol[i];
      JSONObject pJSONCompany = loadJSONObject(IEX_URL + pCurrStockSymbol + IEX_COMPANY_QUERY);
      JSONObject pJSONStats = loadJSONObject(IEX_URL + pCurrStockSymbol + IEX_COSTATS_QUERY);
      TableRow newRow = pCompanyData.addRow();

      newRow.setString("symbol", pCurrStockSymbol);
      newRow.setString("companyName", pJSONCompany.getString("companyName"));
      newRow.setString("exchange", pJSONCompany.getString("exchange"));
      newRow.setString("industry", pJSONCompany.getString("industry"));
      newRow.setString("website", pJSONCompany.getString("website"));
      newRow.setString("CEO", pJSONCompany.getString("CEO"));
      newRow.setString("issueType", pJSONCompany.getString("issueType"));
      newRow.setString("sector", pJSONCompany.getString("sector"));
      newRow.setString("symbol", pCurrStockSymbol);
      newRow.setFloat("marketcap", pJSONStats.getFloat("marketcap"));
      newRow.setFloat("week52change", pJSONStats.getFloat("week52change"));

      String pPercComplete = String.format("%.1f", float(i+1) / float(pCompanyCount) * 100);
      String companyLoadStatus = str(i+1) + " companies loaded. " + pPercComplete + "% complete.";
      println(companyLoadStatus);
    }
    println("Complete:  load company data for treemap chart");
    return pCompanyData;
  }

  TableRow getCompanyRow(String pStockSymbol) {
    for (TableRow row : this.companyDataTable.rows()) {
      String thisCompanySymbol = row.getString("symbol");
      if (thisCompanySymbol.equals(pStockSymbol)) {
        return row;
      }
    }
    return null;
  }
}