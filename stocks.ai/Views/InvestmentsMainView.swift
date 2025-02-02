import SwiftUI

struct InvestmentsMainView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: InvestmentsView()) {
                    HStack {
                        Image(systemName: "chart.pie.fill")
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("Portfolios")
                                .font(.headline)
                            Text("Manage your stock portfolios")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Investments")
        }
    }
} 