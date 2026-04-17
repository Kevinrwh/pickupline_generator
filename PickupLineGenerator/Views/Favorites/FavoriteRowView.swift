import SwiftUI

struct FavoriteRowView: View {
    let line: PickupLine
    let onDelete: () -> Void

    @State private var offset: CGFloat = 0

    private let revealThreshold: CGFloat = -80
    private let deleteThreshold: CGFloat = -200

    var body: some View {
        ZStack(alignment: .trailing) {
            // Delete background
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                .fill(Color.red)
                .overlay(alignment: .trailing) {
                    Image(systemName: "trash.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .padding(.trailing, 24)
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
                            if value.translation.width < deleteThreshold {
                                // Full swipe — delete
                                withAnimation(.easeOut(duration: 0.2)) {
                                    offset = -500
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    onDelete()
                                }
                            } else if value.translation.width < revealThreshold {
                                // Partial swipe — reveal delete button
                                withAnimation(.easeOut(duration: 0.2)) {
                                    offset = revealThreshold
                                }
                            } else {
                                // Snap back
                                withAnimation(.easeOut(duration: 0.2)) {
                                    offset = 0
                                }
                            }
                        }
                )
                .onTapGesture {
                    // Tap to dismiss if revealed
                    if offset < 0 {
                        withAnimation(.easeOut(duration: 0.2)) {
                            offset = 0
                        }
                    }
                }
        }
        .onTapGesture {
            // Tap red area to delete when revealed
            if offset < 0 {
                withAnimation(.easeOut(duration: 0.2)) {
                    offset = -500
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    onDelete()
                }
            }
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
