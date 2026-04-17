import Testing
import Foundation
@testable import PickupLineGenerator

@Suite("FavoritesService Tests")
struct FavoritesServiceTests {
    private func makeService() -> (FavoritesService, UserDefaults) {
        let suiteName = "test.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        let service = FavoritesService(defaults: defaults)
        return (service, defaults)
    }

    private func makeLine(text: String = "Test line", topic: String = "test") -> PickupLine {
        PickupLine(text: text, topic: topic)
    }

    @Test func addFavorite() {
        let (service, _) = makeService()
        let line = makeLine()
        service.add(line)
        #expect(service.favorites.count == 1)
        #expect(service.favorites.first?.text == "Test line")
    }

    @Test func addDuplicateIsIgnored() {
        let (service, _) = makeService()
        let line = makeLine()
        service.add(line)
        service.add(line)
        #expect(service.favorites.count == 1)
    }

    @Test func removeFavorite() {
        let (service, _) = makeService()
        let line = makeLine()
        service.add(line)
        service.remove(id: line.id)
        #expect(service.favorites.isEmpty)
    }

    @Test func removeNonexistentIdDoesNothing() {
        let (service, _) = makeService()
        let line = makeLine()
        service.add(line)
        service.remove(id: UUID())
        #expect(service.favorites.count == 1)
    }

    @Test func isFavorite() {
        let (service, _) = makeService()
        let line = makeLine()
        #expect(!service.isFavorite(line))
        service.add(line)
        #expect(service.isFavorite(line))
    }

    @Test func persistsAcrossInstances() {
        let suiteName = "test.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)

        let service1 = FavoritesService(defaults: defaults)
        let line = makeLine()
        service1.add(line)

        let service2 = FavoritesService(defaults: defaults)
        #expect(service2.favorites.count == 1)
        #expect(service2.favorites.first?.id == line.id)
    }

    @Test func multipleAddAndRemove() {
        let (service, _) = makeService()
        let line1 = makeLine(text: "Line 1")
        let line2 = makeLine(text: "Line 2")
        let line3 = makeLine(text: "Line 3")

        service.add(line1)
        service.add(line2)
        service.add(line3)
        #expect(service.favorites.count == 3)

        service.remove(id: line2.id)
        #expect(service.favorites.count == 2)
        #expect(!service.isFavorite(line2))
        #expect(service.isFavorite(line1))
        #expect(service.isFavorite(line3))
    }
}
