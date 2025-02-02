//
//  PortfolioView.swift
//  stocks.ai
//
//  Created by Varun Kohli on 2/1/25.
//

import SwiftUI

struct PortfolioView: View {

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
    }
}
