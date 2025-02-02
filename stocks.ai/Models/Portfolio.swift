import Foundation

struct Portfolio: Identifiable {
  let id = UUID()
  let name: String
  var stocks: [Stock]
  
  var totalValue: Double {
    stocks.reduce(0) { $0 + $1.currentValue }
  }
  
  var totalCost: Double {
    stocks.reduce(0) { $0 + ($1.shares * $1.purchasePrice) }
  }
  
  var gainPercentage: Double {
    ((totalValue - totalCost) / totalCost) * 100
  }
}
