import SwiftUI

struct ImportInvestmentsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var portfolios: [Portfolio]
    @State private var username = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var error: String?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Yahoo Finance Account")) {
                    TextField("Email", text: $username)
                        .textContentType(.emailAddress)
                        //.autocapitalization(.none)
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                }
                
                if let error = error {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button(action: importPortfolios) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text("Import Portfolios")
                        }
                    }
                    .disabled(username.isEmpty || password.isEmpty || isLoading)
                }
            }
            .navigationTitle("Import Investments")
            //.navigationBarItems(trailing: Button("Cancel") {
            //    dismiss()
            //})
        }
    }
    
    private func importPortfolios() {
        isLoading = true
        error = nil
        
        // Here you would implement the Yahoo Finance API integration
        // For now, we'll simulate the import with a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // TODO: Implement actual Yahoo Finance API integration
            // This is just example data
            portfolios = [
                Portfolio(name: "Growth", stocks: [
                    Stock(symbol: "AAPL", companyName: "Apple Inc.", 
                         shares: 10, currentPrice: 175.43, purchasePrice: 150.0),
                    Stock(symbol: "MSFT", companyName: "Microsoft", 
                         shares: 5, currentPrice: 338.11, purchasePrice: 300.0)
                ]),
                Portfolio(name: "Dividend", stocks: [
                    Stock(symbol: "KO", companyName: "Coca-Cola", 
                         shares: 20, currentPrice: 60.45, purchasePrice: 55.0),
                    Stock(symbol: "JNJ", companyName: "Johnson & Johnson", 
                         shares: 8, currentPrice: 152.32, purchasePrice: 140.0)
                ])
            ]
            
            isLoading = false
            dismiss()
        }
    }
} 
