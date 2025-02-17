import SwiftUI

struct ImportInvestmentsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var portfolios: [Portfolio]
    @State private var isLoading = false
    @State private var error: String?
    
    private let yahooService = YahooFinanceService()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView("Connecting to Yahoo Finance...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Image(systemName: "link.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Connect Yahoo Finance")
                        .font(.headline)
                    
                    Text("Sign in with your Yahoo account to import your portfolios")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    if let error = error {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: importPortfolios) {
                        HStack {
                            Image(systemName: "link.badge.plus")
                            Text("Sign in with Yahoo")
                        }
                        .padding()
                        .background(.bar)
                        .cornerRadius(20)
                    }
                }
            }
            .padding()
            .navigationTitle("Import Investments")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func importPortfolios() {
        isLoading = true
        error = nil
        
        Task {
            do {
                try await yahooService.authenticate()
                let importedPortfolios = try await yahooService.fetchPortfolios()
                
                await MainActor.run {
                    portfolios = importedPortfolios
                    isLoading = false
                    dismiss()
                }
            } catch let yahooError as YahooFinanceError {
                await MainActor.run {
                    error = yahooError.message
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = "An unexpected error occurred"
                    isLoading = false
                }
            }
        }
    }
} 
