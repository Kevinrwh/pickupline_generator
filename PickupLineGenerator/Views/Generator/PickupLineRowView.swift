import SwiftUI

struct PickupLineRowView: View {
    let line: PickupLine
    let isFavorite: Bool
    let onCopy: () -> Void
    let onToggleFavorite: () -> Void

    @State private var copied = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(line.text)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 8) {
                Button {
                    onCopy()
                    withAnimation { copied = true }
                    Task {
                        try? await Task.sleep(for: .seconds(1.5))
                        withAnimation { copied = false }
                    }
                } label: {
                    Image(systemName: copied ? "checkmark" : "doc.on.doc")
                        .foregroundStyle(copied ? .green : .secondary)
                }
                .buttonStyle(.borderless)

                Button(action: onToggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(isFavorite ? .red : .secondary)
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        PickupLineRowView(
            line: PickupLine(text: "Are you a black hole? Because you just sucked me in.", topic: "astronomy"),
            isFavorite: false,
            onCopy: {},
            onToggleFavorite: {}
        )
        PickupLineRowView(
            line: PickupLine(text: "Are you made of copper and tellurium? Because you're CuTe.", topic: "chemistry"),
            isFavorite: true,
            onCopy: {},
            onToggleFavorite: {}
        )
    }
}
