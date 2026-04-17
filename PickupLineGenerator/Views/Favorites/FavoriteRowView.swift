import SwiftUI

struct FavoriteRowView: View {
    let line: PickupLine

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(line.text)
                .font(.body)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            HStack {
                Text(line.topic.capitalized)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(AppTheme.accent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(AppTheme.subtleGradient)
                    .clipShape(Capsule())

                Spacer()

                ShareLink(item: line.text) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
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
    FavoriteRowView(
        line: PickupLine(text: "Are you a black hole? Because you just sucked me in.", topic: "astronomy")
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
