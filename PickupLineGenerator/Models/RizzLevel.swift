import Foundation

enum RizzLevel: Int, CaseIterable, Identifiable {
    case sweet = 0
    case smooth = 1
    case bold = 2
    case unhinged = 3

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .sweet: return "Sweet"
        case .smooth: return "Smooth"
        case .bold: return "Bold"
        case .unhinged: return "Unhinged"
        }
    }

    var emoji: String {
        switch self {
        case .sweet: return "🥰"
        case .smooth: return "😎"
        case .bold: return "🔥"
        case .unhinged: return "😈"
        }
    }

    var systemDescription: String {
        switch self {
        case .sweet:
            return """
                You write sweet, wholesome, and genuinely romantic pickup lines. \
                Think: the kind of thing that makes someone smile and feel warm inside. \
                Tender, sincere, and endearing — never sleazy or over the top. \
                Like a love letter distilled into one sentence.
                """
        case .smooth:
            return """
                You write effortlessly smooth and charming pickup lines. \
                Confident but not arrogant, witty but not try-hard. \
                Think: James Bond meets a great stand-up comedian. \
                The kind of line that gets a surprised laugh and a "that was actually good."
                """
        case .bold:
            return """
                You write bold, confident, and flirty pickup lines that push boundaries. \
                Unapologetically forward, a little spicy, but still clever. \
                Think: the kind of thing someone says with full eye contact and a smirk. \
                Risky but rewarding — the line between charm and audacity.
                """
        case .unhinged:
            return """
                You write absolutely unhinged, chaotic, and wildly creative pickup lines. \
                Throw all rules out the window. Be absurd, unexpected, and hilarious. \
                Think: if a shitposter tried to flirt. Weird metaphors, surreal humor, \
                completely off-the-wall energy. The kind of line that makes someone \
                laugh so hard they have to say yes just out of respect for the audacity.
                """
        }
    }
}
