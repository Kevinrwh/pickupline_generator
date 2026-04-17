import Foundation

class FavoritesService: ObservableObject {
    static let userDefaultsKey = "saved_pickup_lines"

    @Published private(set) var favorites: [PickupLine] = []

    init() {
        load()
    }

    func add(_ line: PickupLine) {
        guard !favorites.contains(where: { $0.id == line.id }) else { return }
        favorites.append(line)
        save()
    }

    func remove(id: UUID) {
        favorites.removeAll { $0.id == id }
        save()
    }

    func isFavorite(_ line: PickupLine) -> Bool {
        favorites.contains(where: { $0.id == line.id })
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(favorites) else { return }
        UserDefaults.standard.set(data, forKey: Self.userDefaultsKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.userDefaultsKey),
              let saved = try? JSONDecoder().decode([PickupLine].self, from: data) else {
            favorites = []
            return
        }
        favorites = saved
    }
}
