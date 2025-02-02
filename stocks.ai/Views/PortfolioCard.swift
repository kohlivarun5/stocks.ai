import SwiftUI

struct PortfolioCard: View {
  let portfolio: Portfolio
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text(portfolio.name)
          .font(.headline)
        Spacer()
        HStack {
          Text("$\(portfolio.totalValue, specifier: "%.2f")")
            .font(.caption)
            .foregroundColor(.secondary)
          Text("•")
            .foregroundColor(.secondary)
          Text(portfolio.gainPercentage >= 0 ? "+" : "")
          Text("\(portfolio.gainPercentage, specifier: "%.1f")%")
            .font(.caption)
            .foregroundColor(portfolio.gainPercentage >= 0 ? .green : .red)
        }
      }
    }
    .padding()
    .cornerRadius(12)
    .shadow(radius: 2)
    .padding(.horizontal)
  }
}
