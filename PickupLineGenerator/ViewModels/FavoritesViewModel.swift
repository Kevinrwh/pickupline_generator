import Foundation

@MainActor
class FavoritesViewModel: ObservableObject {
    private let favoritesService: FavoritesService

    var favorites: [PickupLine] {
        favoritesService.favorites.sorted { $0.createdAt > $1.createdAt }
    }

    init(favoritesService: FavoritesService) {
        self.favoritesService = favoritesService
    }

    func removeFavorite(_ line: PickupLine) {
        favoritesService.remove(id: line.id)
    }

    func refreshFavorites() {
        objectWillChange.send()
    }
}
