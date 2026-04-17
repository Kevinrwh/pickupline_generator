import Foundation

struct ClaudeRequest: Encodable {
    let model: String = "claude-haiku-4-5-20251001"
    let maxTokens: Int = 512
    let temperature: Double = 0.9
    let system: String?
    let messages: [ClaudeMessage]

    enum CodingKeys: String, CodingKey {
        case model, messages, system, temperature
        case maxTokens = "max_tokens"
    }
}

struct ClaudeMessage: Encodable {
    let role: String
    let content: String
}

struct ClaudeResponse: Decodable {
    let content: [ClaudeContent]
}

struct ClaudeContent: Decodable {
    let text: String
}
