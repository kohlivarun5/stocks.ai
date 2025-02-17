import Foundation
import AuthenticationServices

enum YahooFinanceError: Error {
    case authenticationFailed
    case networkError
    case invalidResponse
    case rateLimitExceeded
    case authenticationCancelled
    
    var message: String {
        switch self {
        case .authenticationFailed:
            return "Authentication failed"
        case .networkError:
            return "Network connection error"
        case .invalidResponse:
            return "Unable to fetch portfolios"
        case .rateLimitExceeded:
            return "Too many requests, please try again later"
        case .authenticationCancelled:
            return "Authentication was cancelled"
        }
    }
}

class YahooFinanceService: NSObject, ASWebAuthenticationPresentationContextProviding {
    private let clientId = "dj0yJmk9eVpHN1dDYUdIRFQ3JmQ9WVdrOVdUUldiVTlaZUcwbWNHbzlNQT09JnM9Y29uc3VtZXJzZWNyZXQmc3Y9MCZ4PWFi"
    private let clientSecret = "YOUR_CLIENT_SECRET"
    private let redirectUri = "stocks-ai://oauth-callback"
    private var authToken: String?
    
    @MainActor
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    @MainActor
    func authenticate() async throws {
        let authURL = "https://api.login.yahoo.com/oauth2/request_auth"
        
        var components = URLComponents(string: authURL)!
        components.queryItems = [
            URLQueryItem(name: "client.id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "nonce", value: clientId),
            URLQueryItem(name: "scope", value: "read")
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(
                url: components.url!,
                callbackURLScheme: "stocks-ai"
            ) { callbackURL, error in
                Task { @MainActor in
                    if let error = error {
                        if (error as? ASWebAuthenticationSessionError)?.code == .canceledLogin {
                            continuation.resume(throwing: YahooFinanceError.authenticationCancelled)
                        } else {
                            continuation.resume(throwing: YahooFinanceError.authenticationFailed)
                        }
                        return
                    }
                    
                    guard let callbackURL = callbackURL,
                          let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: true),
                          let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
                        continuation.resume(throwing: YahooFinanceError.authenticationFailed)
                        return
                    }
                    
                    do {
                        try await self.exchangeCodeForToken(code)
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            Task { @MainActor in
                session.presentationContextProvider = self
                session.prefersEphemeralWebBrowserSession = true
                
                if !session.start() {
                    continuation.resume(throwing: YahooFinanceError.authenticationFailed)
                }
            }
        }
    }
    
    private func exchangeCodeForToken(_ code: String) async throws {
        let tokenURL = "https://api.login.yahoo.com/oauth2/get_token"
        
        var request = URLRequest(url: URL(string: tokenURL)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let credentials = "\(clientId):\(clientSecret)"
        if let credentialsData = credentials.data(using: .utf8) {
            let base64Credentials = credentialsData.base64EncodedString()
            request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        }
        
        let body = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectUri
        ]
        
        request.httpBody = body.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw YahooFinanceError.authenticationFailed
        }
        
        let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
        self.authToken = authResponse.access_token
    }
    
    func fetchPortfolios() async throws -> [Portfolio] {
        guard let authToken = authToken else {
            throw YahooFinanceError.authenticationFailed
        }
        
        let portfoliosURL = "https://query1.finance.yahoo.com/v7/finance/portfolios"
        var request = URLRequest(url: URL(string: portfoliosURL)!)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw YahooFinanceError.networkError
        }
        
        switch httpResponse.statusCode {
        case 200:
            let portfoliosResponse = try JSONDecoder().decode(PortfoliosResponse.self, from: data)
            return mapToPortfolios(portfoliosResponse)
        case 429:
            throw YahooFinanceError.rateLimitExceeded
        case 401:
            throw YahooFinanceError.authenticationFailed
        default:
            throw YahooFinanceError.invalidResponse
        }
    }
    
    private func mapToPortfolios(_ response: PortfoliosResponse) -> [Portfolio] {
        // Map Yahoo Finance response to our Portfolio model
        return response.portfolios.map { yahooPortfolio in
            Portfolio(
                name: yahooPortfolio.name,
                stocks: yahooPortfolio.holdings.map { holding in
                    Stock(
                        symbol: holding.symbol,
                        companyName: holding.companyName,
                        shares: holding.shares,
                        currentPrice: holding.currentPrice,
                        purchasePrice: holding.purchasePrice
                    )
                }
            )
        }
    }
}

// Response models
private struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let token_type: String
}

private struct PortfoliosResponse: Codable {
    let portfolios: [YahooPortfolio]
}

private struct YahooPortfolio: Codable {
    let name: String
    let holdings: [YahooHolding]
}

private struct YahooHolding: Codable {
    let symbol: String
    let companyName: String
    let shares: Double
    let currentPrice: Double
    let purchasePrice: Double
} 
