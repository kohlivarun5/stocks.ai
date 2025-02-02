import SwiftUI

struct PortfolioCard: View {
    let portfolio: Portfolio
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(portfolio.name)
                    .font(.headline)
                Spacer()
                Text("$\(portfolio.totalValue, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.green)
            }
            
            Divider()
            
            ForEach(portfolio.stocks) { stock in
                StockRow(stock: stock)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
} 