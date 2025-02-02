import SwiftUI

struct InvestmentsView: View {
    @State private var portfolios: [Portfolio] = [
        Portfolio(name: "Growth", stocks: [
            Stock(symbol: "AAPL", companyName: "Apple Inc.", shares: 10, currentPrice: 175.43),
            Stock(symbol: "MSFT", companyName: "Microsoft", shares: 5, currentPrice: 338.11)
        ]),
        Portfolio(name: "Dividend", stocks: [
            Stock(symbol: "KO", companyName: "Coca-Cola", shares: 20, currentPrice: 60.45),
            Stock(symbol: "JNJ", companyName: "Johnson & Johnson", shares: 8, currentPrice: 152.32)
        ])
    ]
    
    var body: some View {
        List {
            ForEach(portfolios) { portfolio in

              NavigationLink(destination: PortfolioView(portfolio:portfolio)) {
                HStack {
                        Image(systemName: "chart.pie.fill")
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text(portfolio.name)
                                .font(.headline)
                            Text("Manage your stock portfolios")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("My Portfolios")
    }
} 
