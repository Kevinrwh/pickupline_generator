import SwiftUI

struct GeneratorView: View {
    @EnvironmentObject private var favoritesService: FavoritesService
    @StateObject private var viewModel: GeneratorViewModel
    @FocusState private var isInputFocused: Bool

    init(favoritesService: FavoritesService) {
        _viewModel = StateObject(wrappedValue: GeneratorViewModel(favoritesService: favoritesService))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                inputSection
                    .padding()

                Divider()

                resultSection
            }
            .navigationTitle("Pickup Lines")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { isInputFocused = false }
                }
            }
        }
    }

    private var inputSection: some View {
        VStack(spacing: 12) {
            TextField("Enter a topic or name…", text: $viewModel.topic)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.go)
                .autocorrectionDisabled()
                .focused($isInputFocused)
                .onSubmit { viewModel.generate() }

            Button(action: viewModel.generate) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Generate")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isLoading || viewModel.topic.trimmingCharacters(in: .whitespaces).isEmpty)

            if let error = viewModel.error {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                    Text(error.localizedDescription)
                        .font(.footnote)
                }
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.opacity)
            }
        }
        .animation(.default, value: viewModel.error?.localizedDescription)
    }

    private var resultSection: some View {
        Group {
            if viewModel.lines.isEmpty && !viewModel.isLoading {
                VStack(spacing: 12) {
                    Image(systemName: "heart.text.square")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("No Lines Yet")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Enter a topic above and tap Generate.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(viewModel.lines) { line in
                    PickupLineRowView(
                        line: line,
                        isFavorite: viewModel.isFavorite(line),
                        onCopy: { viewModel.copyToClipboard(line) },
                        onToggleFavorite: { viewModel.toggleFavorite(line) }
                    )
                }
                .listStyle(.plain)
                .animation(.default, value: viewModel.lines.map(\.id))
            }
        }
    }
}

#Preview {
    let service = FavoritesService()
    return GeneratorView(favoritesService: service)
        .environmentObject(service)
}
