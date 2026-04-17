import SwiftUI

enum AppTheme {
    // MARK: - Gradients

    static let primaryGradient = LinearGradient(
        colors: [Color(hex: 0xFD267A), Color(hex: 0xFF6036)],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let subtleGradient = LinearGradient(
        colors: [Color(hex: 0xFD267A).opacity(0.1), Color(hex: 0xFF6036).opacity(0.1)],
        startPoint: .leading,
        endPoint: .trailing
    )

    // MARK: - Colors

    static let accent = Color(hex: 0xFD267A)

    // MARK: - Background

    static let backgroundGradient = LinearGradient(
        colors: [
            Color(hex: 0xFFF1F3),
            Color(hex: 0xFFF5EE),
            Color(hex: 0xFFF8F0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let backgroundGradientDark = LinearGradient(
        colors: [
            Color(hex: 0x1C1018),
            Color(hex: 0x1A1210),
            Color(hex: 0x141414)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Card Style

    static let cardCornerRadius: CGFloat = 16
    static let cardShadowRadius: CGFloat = 4
    static let cardShadowY: CGFloat = 2
}

// MARK: - Themed Background

struct ThemedBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        if colorScheme == .dark {
            AppTheme.backgroundGradientDark.ignoresSafeArea()
        } else {
            AppTheme.backgroundGradient.ignoresSafeArea()
        }
    }
}

// MARK: - Gradient Button Style

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(AppTheme.primaryGradient)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Color Hex Init

extension Color {
    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}
