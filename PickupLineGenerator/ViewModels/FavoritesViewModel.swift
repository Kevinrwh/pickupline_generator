import Foundation
import UIKit

@MainActor
class FavoritesViewModel: ObservableObject {
    private let favoritesService: FavoritesService

    var favorites: [PickupLine] {
        favoritesService.favorites.sorted { $0.createdAt > $1.createdAt }
    }

    init(favoritesService: FavoritesService) {
        self.favoritesService = favoritesService
    }

    func delete(at offsets: IndexSet) {
        let sorted = favorites
        offsets.forEach { index in
            favoritesService.remove(id: sorted[index].id)
        }
    }

    func copyToClipboard(_ line: PickupLine) {
        UIPasteboard.general.string = line.text
    }

    func refreshFavorites() {
        objectWillChange.send()
    }
}
