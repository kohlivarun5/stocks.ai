import SwiftUI

struct StockRow: View {
  let stock: Stock
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(stock.symbol)
          .font(.subheadline)
          .bold()
        HStack {
          Text("\(stock.shares, specifier: "%.1f") shares")
            .font(.caption)
            .foregroundColor(.secondary)
          Text("•")
            .font(.caption)
            .foregroundColor(.secondary)
          Text(stock.gainPercentage >= 0 ? "+" : "")
          Text("\(stock.gainPercentage, specifier: "%.1f")%")
            .font(.caption)
            .foregroundColor(stock.gainPercentage >= 0 ? .green : .red)
        }
      }
      
      Spacer()
      
      VStack(alignment: .trailing) {
        Text("$\(stock.currentValue, specifier: "%.2f")")
          .font(.subheadline)
        Text("$\(stock.currentPrice, specifier: "%.2f")")
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
    .padding(.vertical, 4)
  }
}
