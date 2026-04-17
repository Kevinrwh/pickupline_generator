import Foundation

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var apiKeyInput: String = ""
    @Published var isSaved: Bool = false
    @Published var error: AppError?

    var hasExistingKey: Bool {
        (try? KeychainService.retrieve()) != nil
    }

    func saveKey() {
        let trimmed = apiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        do {
            try KeychainService.save(apiKey: trimmed)
            apiKeyInput = ""
            isSaved = true
            error = nil
            // Brief confirmation feedback
            Task {
                try? await Task.sleep(for: .seconds(2))
                isSaved = false
            }
        } catch let appError as AppError {
            error = appError
        } catch {
            self.error = .keychainError(error.localizedDescription)
        }
    }

    func clearKey() {
        try? KeychainService.delete()
        apiKeyInput = ""
        isSaved = false
        error = nil
    }
}
