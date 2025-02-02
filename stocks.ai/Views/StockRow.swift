import SwiftUI

struct StockRow: View {
    let stock: Stock
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stock.symbol)
                    .font(.subheadline)
                    .bold()
                Text(stock.companyName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("$\(stock.currentValue, specifier: "%.2f")")
                    .font(.subheadline)
                Text("\(stock.shares, specifier: "%.2f") shares")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
} 