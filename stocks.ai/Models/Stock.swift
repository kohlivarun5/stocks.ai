import Foundation

struct Stock: Identifiable {
  let id = UUID()
  let symbol: String
  let companyName: String
  let shares: Double
  let currentPrice: Double
  let purchasePrice: Double
  
  var currentValue: Double {
    shares * currentPrice
  }
  
  var gainPercentage: Double {
    ((currentPrice - purchasePrice) / purchasePrice) * 100
  }
}
