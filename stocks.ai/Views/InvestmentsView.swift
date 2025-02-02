import SwiftUI

struct InvestmentsView: View {
  @State private var portfolios: [Portfolio] = [
    Portfolio(name: "Growth", stocks: [
      Stock(symbol: "AAPL", companyName: "Apple Inc.", shares: 10, currentPrice: 175.43, purchasePrice: 150.0),
      Stock(symbol: "MSFT", companyName: "Microsoft", shares: 5, currentPrice: 338.11, purchasePrice: 300.0)
    ]),
    Portfolio(name: "Dividend", stocks: [
      Stock(symbol: "KO", companyName: "Coca-Cola", shares: 20, currentPrice: 60.45, purchasePrice: 55.0),
      Stock(symbol: "JNJ", companyName: "Johnson & Johnson", shares: 8, currentPrice: 152.32, purchasePrice: 140.0)
    ])
  ]
  
  var totalAssets: Double {
    portfolios.reduce(0) { $0 + $1.totalValue }
  }
  
  var body: some View {
    List {
      Section(header: Text("Total Assets: $\(totalAssets, specifier: "%.2f")")) {
        ForEach(portfolios) { portfolio in
          NavigationLink(destination: PortfolioView(portfolio: portfolio)) {
            PortfolioCard(portfolio: portfolio)
          }
        }
      }
    }
    .navigationTitle("My Portfolios")
  }
}
