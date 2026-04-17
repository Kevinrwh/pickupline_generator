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
            ScrollView {
                VStack(spacing: 20) {
                    inputSection
                    resultSection
                }
                .padding()
            }
            .background { ThemedBackground() }
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
        VStack(spacing: 16) {
            // Topic input
            HStack(spacing: 12) {
                Image(systemName: "flame.fill")
                    .foregroundStyle(AppTheme.accent)
                    .font(.title3)

                TextField("A name or topic…", text: $viewModel.topic)
                    .submitLabel(.go)
                    .autocorrectionDisabled()
                    .focused($isInputFocused)
                    .onSubmit { viewModel.generate() }
            }
            .padding()
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 14))

            // Rizz level picker
            VStack(alignment: .leading, spacing: 8) {
                Text("Rizz Level")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                Picker("Rizz Level", selection: $viewModel.rizzLevel) {
                    ForEach(RizzLevel.allCases) { level in
                        Text("\(level.emoji) \(level.label)").tag(level)
                    }
                }
                .pickerStyle(.segmented)
            }

            // Generate button
            Button(action: viewModel.generate) {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Generate 🔥")
                }
            }
            .buttonStyle(GradientButtonStyle())
            .disabled(viewModel.isLoading || viewModel.topic.trimmingCharacters(in: .whitespaces).isEmpty)
            .opacity(viewModel.topic.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)

            // Error banner
            if let error = viewModel.error {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.circle.fill")
                    Text(error.localizedDescription)
                        .font(.footnote)
                }
                .foregroundStyle(.white)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.red.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.default, value: viewModel.error?.localizedDescription)
    }

    private var resultSection: some View {
        Group {
            if viewModel.lines.isEmpty && !viewModel.isLoading {
                emptyState
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.lines) { line in
                        PickupLineRowView(
                            line: line,
                            isFavorite: viewModel.isFavorite(line),
                            onToggleFavorite: { viewModel.toggleFavorite(line) }
                        )
                    }
                }
                .animation(.default, value: viewModel.lines.map(\.id))
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 56))
                .foregroundStyle(AppTheme.primaryGradient)
            Text("Ready to Rizz?")
                .font(.title2.weight(.bold))
            Text("Enter a topic and tap Generate.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 60)
    }
}

#Preview {
    let service = FavoritesService()
    return GeneratorView(favoritesService: service)
        .environmentObject(service)
}
