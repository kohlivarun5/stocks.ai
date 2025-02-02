import Foundation

struct Stock: Identifiable {
    let id = UUID()
    let symbol: String
    let companyName: String
    let shares: Double
    let currentPrice: Double
    
    var currentValue: Double {
        shares * currentPrice
    }
} 
