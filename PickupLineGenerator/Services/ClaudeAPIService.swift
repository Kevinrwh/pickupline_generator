import Foundation

actor ClaudeAPIService {
    private let endpoint = URL(string: "https://api.anthropic.com/v1/messages")!

    func generatePickupLines(topic: String, apiKey: String, rizzLevel: RizzLevel = .smooth) async throws -> [String] {
        let systemPrompt = """
            \(rizzLevel.systemDescription) \
            You never use overused lines like "Are you a magician?" or "Did it hurt when you fell from heaven?" \
            Every line should feel fresh and original.
            """

        let prompt = "Give me 5 pickup lines about \(topic). Numbered 1-5, one per line, nothing else."

        let requestBody = ClaudeRequest(
            system: systemPrompt,
            messages: [ClaudeMessage(role: "user", content: prompt)]
        )

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.networkFailure(URLError(.badServerResponse))
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? "no body"
            print("[ClaudeAPI] HTTP \(httpResponse.statusCode): \(body)")
            throw AppError.httpError(httpResponse.statusCode)
        }

        let claudeResponse = try JSONDecoder().decode(ClaudeResponse.self, from: data)
        guard let text = claudeResponse.content.first?.text else {
            throw AppError.emptyResponse
        }

        let lines = parseLines(from: text)
        if lines.isEmpty {
            throw AppError.emptyResponse
        }
        return lines
    }

    func parseLines(from text: String) -> [String] {
        text
            .components(separatedBy: .newlines)
            .map { line in
                // Strip leading "1. " / "2. " etc.
                let stripped = line.trimmingCharacters(in: .whitespaces)
                if stripped.count > 2,
                   let first = stripped.first, first.isNumber,
                   stripped.dropFirst().first == "." {
                    return String(stripped.dropFirst(2)).trimmingCharacters(in: .whitespaces)
                }
                return stripped
            }
            .filter { !$0.isEmpty }
            .prefix(5)
            .map { $0 }
    }
}
