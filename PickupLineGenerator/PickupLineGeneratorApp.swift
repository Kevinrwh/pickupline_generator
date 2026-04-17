import SwiftUI

@main
struct PickupLineGeneratorApp: App {
    @StateObject private var favoritesService = FavoritesService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoritesService)
        }
    }
}
