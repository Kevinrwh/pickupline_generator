import Foundation

struct PickupLine: Identifiable, Codable, Equatable {
    let id: UUID
    let text: String
    let topic: String
    let createdAt: Date

    init(id: UUID = UUID(), text: String, topic: String, createdAt: Date = Date()) {
        self.id = id
        self.text = text
        self.topic = topic
        self.createdAt = createdAt
    }
}
