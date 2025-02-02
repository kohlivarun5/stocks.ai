import SwiftUI

struct InvestmentsView: View {
  @State private var portfolios: [Portfolio] = []
  @State private var showingImportSheet = false
  
  var totalAssets: Double {
    portfolios.reduce(0) { $0 + $1.totalValue }
  }
  
  var body: some View {
    Group {
      if portfolios.isEmpty {
        VStack(spacing: 20) {
          Image(systemName: "chart.pie")
            .font(.system(size: 50))
            .foregroundColor(.blue)
          Text("No Portfolios Yet")
            .font(.headline)
          Text("Import your existing investments from Yahoo Finance")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
          Button(action: {
            showingImportSheet = true
          }) {
            HStack {
              Image(systemName: "square.and.arrow.down")
              Text("Import from Yahoo Finance")
            }
            .padding()
            .background(.bar)
            .cornerRadius(20)
          }
        }
        .padding()
      } else {
        List {
          Section(header: Text("Total Assets: $\(totalAssets, specifier: "%.2f")")) {
            ForEach(portfolios) { portfolio in
              NavigationLink(destination: PortfolioView(portfolio: portfolio)) {
                PortfolioCard(portfolio: portfolio)
              }
            }
          }
        }
      }
    }
    .navigationTitle("Investments")
    .sheet(isPresented: $showingImportSheet) {
      ImportInvestmentsView(portfolios: $portfolios)
    }
  }
}

#Preview {
  InvestmentsView()
    .modelContainer(for: Item.self, inMemory: true)
}
