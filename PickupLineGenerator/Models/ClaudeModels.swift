import Foundation

struct ClaudeRequest: Encodable {
    let model: String = "claude-haiku-4-5-20251001"
    let maxTokens: Int = 512
    let messages: [ClaudeMessage]

    enum CodingKeys: String, CodingKey {
        case model, messages
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
