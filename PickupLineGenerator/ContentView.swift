import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var favoritesService: FavoritesService

    var body: some View {
        TabView {
            GeneratorView(favoritesService: favoritesService)
                .tabItem {
                    Label("Generate", systemImage: "wand.and.stars")
                }

            FavoritesView(favoritesService: favoritesService)
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(FavoritesService())
}
