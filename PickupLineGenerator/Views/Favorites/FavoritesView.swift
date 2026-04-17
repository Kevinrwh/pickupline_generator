import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favoritesService: FavoritesService
    @StateObject private var viewModel: FavoritesViewModel

    init(favoritesService: FavoritesService) {
        _viewModel = StateObject(wrappedValue: FavoritesViewModel(favoritesService: favoritesService))
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.favorites.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.favorites) { line in
                                FavoriteRowView(line: line)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            viewModel.removeFavorite(line)
                                        } label: {
                                            Label("Remove", systemImage: "heart.slash")
                                        }
                                    }
                            }
                        }
                        .padding()
                        .animation(.default, value: viewModel.favorites.map(\.id))
                    }
                    .background { ThemedBackground() }
                }
            }
            .navigationTitle("Favorites")
        }
        .onReceive(favoritesService.$favorites) { _ in
            viewModel.refreshFavorites()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash.fill")
                .font(.system(size: 56))
                .foregroundStyle(AppTheme.primaryGradient)
            Text("No Favorites Yet")
                .font(.title2.weight(.bold))
            Text("Generate lines and tap ♥ to save them.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background { ThemedBackground() }
    }
}

#Preview {
    let service = FavoritesService()
    return FavoritesView(favoritesService: service)
        .environmentObject(service)
}
