import SwiftUI

struct PickupLineRowView: View {
    let line: PickupLine
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(line.text)
                .font(.body)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            HStack {
                Spacer()

                ShareLink(item: line.text) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.borderless)

                Button(action: onToggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.subheadline)
                        .foregroundStyle(isFavorite ? AppTheme.accent : .secondary)
                }
                .buttonStyle(.borderless)
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
        .shadow(color: .black.opacity(0.06), radius: AppTheme.cardShadowRadius, y: AppTheme.cardShadowY)
    }
}

#Preview {
    VStack(spacing: 12) {
        PickupLineRowView(
            line: PickupLine(text: "Are you a black hole? Because you just sucked me in.", topic: "astronomy"),
            isFavorite: false,
            onToggleFavorite: {}
        )
        PickupLineRowView(
            line: PickupLine(text: "Are you made of copper and tellurium? Because you're CuTe.", topic: "chemistry"),
            isFavorite: true,
            onToggleFavorite: {}
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
