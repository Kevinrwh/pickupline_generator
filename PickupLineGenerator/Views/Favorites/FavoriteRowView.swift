import SwiftUI

struct FavoriteRowView: View {
    let line: PickupLine
    let onDelete: () -> Void

    @State private var offset: CGFloat = 0
    @State private var showDelete = false

    private let deleteThreshold: CGFloat = -80

    var body: some View {
        ZStack(alignment: .trailing) {
            // Delete background
            if showDelete {
                HStack {
                    Spacer()
                    Button(action: onDelete) {
                        Image(systemName: "trash.fill")
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 60)
                    }
                }
                .padding(.trailing, 8)
            }

            // Card content
            cardContent
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.width < 0 {
                                offset = value.translation.width
                            }
                        }
                        .onEnded { value in
                            withAnimation(.easeOut(duration: 0.2)) {
                                if value.translation.width < deleteThreshold {
                                    showDelete = true
                                    offset = deleteThreshold
                                } else {
                                    showDelete = false
                                    offset = 0
                                }
                            }
                        }
                )
        }
    }

    private var cardContent: some View {
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
        line: PickupLine(text: "Are you a black hole? Because you just sucked me in.", topic: "astronomy"),
        onDelete: {}
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
