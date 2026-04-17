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
                    VStack(spacing: 12) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text("No Favorites Yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("Generate lines and tap ♥ to save them.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.favorites) { line in
                            FavoriteRowView(
                                line: line,
                                onCopy: { viewModel.copyToClipboard(line) }
                            )
                        }
                        .onDelete { viewModel.delete(at: $0) }
                    }
                    .listStyle(.plain)
                    .animation(.default, value: viewModel.favorites.map(\.id))
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                if !viewModel.favorites.isEmpty {
                    EditButton()
                }
            }
        }
        .onReceive(favoritesService.$favorites) { _ in
            // Trigger view update when favorites change from GeneratorView
            viewModel.refreshFavorites()
        }
    }
}

#Preview {
    let service = FavoritesService()
    return FavoritesView(favoritesService: service)
        .environmentObject(service)
}
