import Foundation

enum AppError: LocalizedError {
    case noAPIKey
    case emptyTopic
    case networkFailure(Error)
    case httpError(Int)
    case decodingFailure(Error)
    case emptyResponse
    case keychainError(String)

    var errorDescription: String? {
        switch self {
        case .noAPIKey:
            return "No API key set. Go to Settings and enter your Anthropic API key."
        case .emptyTopic:
            return "Please enter a topic or name first."
        case .networkFailure(let error):
            return "Network error: \(error.localizedDescription)"
        case .httpError(let code):
            if code == 401 {
                return "Invalid API key (HTTP 401). Check your key in Settings."
            } else if code == 403 {
                return "API key not authorized (HTTP 403). Check your key permissions."
            } else {
                return "API error (HTTP \(code)). Please try again."
            }
        case .decodingFailure:
            return "Unexpected response from API. Please try again."
        case .emptyResponse:
            return "The API returned no lines. Try a different topic."
        case .keychainError(let message):
            return "Keychain error: \(message)"
        }
    }
}
