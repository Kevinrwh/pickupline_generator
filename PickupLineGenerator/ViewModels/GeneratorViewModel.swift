import Foundation
import UIKit

@MainActor
class GeneratorViewModel: ObservableObject {
    @Published var topic: String = ""
    @Published var lines: [PickupLine] = []
    @Published var isLoading: Bool = false
    @Published var error: AppError?

    private let apiService = ClaudeAPIService()
    private let favoritesService: FavoritesService

    init(favoritesService: FavoritesService) {
        self.favoritesService = favoritesService
    }

    func generate() {
        let trimmed = topic.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            error = .emptyTopic
            return
        }

        let apiKey: String
        do {
            apiKey = try KeychainService.retrieve()
        } catch let appError as AppError {
            error = appError
            return
        } catch {
            self.error = .keychainError(error.localizedDescription)
            return
        }

        isLoading = true
        error = nil

        Task {
            do {
                let rawLines = try await apiService.generatePickupLines(topic: trimmed, apiKey: apiKey)
                lines = rawLines.map { PickupLine(text: $0, topic: trimmed) }
            } catch let appError as AppError {
                error = appError
            } catch {
                self.error = .networkFailure(error)
            }
            isLoading = false
        }
    }

    func toggleFavorite(_ line: PickupLine) {
        if favoritesService.isFavorite(line) {
            favoritesService.remove(id: line.id)
        } else {
            favoritesService.add(line)
        }
    }

    func isFavorite(_ line: PickupLine) -> Bool {
        favoritesService.isFavorite(line)
    }

    func copyToClipboard(_ line: PickupLine) {
        UIPasteboard.general.string = line.text
    }
}
