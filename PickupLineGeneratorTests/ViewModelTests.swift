import Testing
import Foundation
@testable import PickupLineGenerator

@Suite("SettingsViewModel Tests")
struct SettingsViewModelTests {
    @Test @MainActor func saveKeyWithEmptyInputDoesNothing() {
        let vm = SettingsViewModel()
        vm.apiKeyInput = ""
        vm.saveKey()
        #expect(!vm.isSaved)
        #expect(vm.error == nil)
    }

    @Test @MainActor func saveKeyWithWhitespaceOnlyDoesNothing() {
        let vm = SettingsViewModel()
        vm.apiKeyInput = "   "
        vm.saveKey()
        #expect(!vm.isSaved)
        #expect(vm.error == nil)
    }
}

@Suite("GeneratorViewModel Tests")
struct GeneratorViewModelTests {
    @MainActor private func makeViewModel() -> GeneratorViewModel {
        let defaults = UserDefaults(suiteName: "test.\(UUID().uuidString)")!
        let favoritesService = FavoritesService(defaults: defaults)
        return GeneratorViewModel(favoritesService: favoritesService)
    }

    @Test @MainActor func generateWithEmptyTopicShowsError() {
        let vm = makeViewModel()
        vm.topic = ""
        vm.generate()
        #expect(vm.error != nil)
    }

    @Test @MainActor func generateWithWhitespaceOnlyTopicShowsError() {
        let vm = makeViewModel()
        vm.topic = "   "
        vm.generate()
        #expect(vm.error != nil)
    }

    @Test @MainActor func toggleFavorite() {
        let defaults = UserDefaults(suiteName: "test.\(UUID().uuidString)")!
        let favoritesService = FavoritesService(defaults: defaults)
        let vm = GeneratorViewModel(favoritesService: favoritesService)
        let line = PickupLine(text: "Test", topic: "test")

        #expect(!vm.isFavorite(line))
        vm.toggleFavorite(line)
        #expect(vm.isFavorite(line))
        vm.toggleFavorite(line)
        #expect(!vm.isFavorite(line))
    }
}

@Suite("FavoritesViewModel Tests")
struct FavoritesViewModelTests {
    @Test @MainActor func favoritesAreSortedNewestFirst() {
        let defaults = UserDefaults(suiteName: "test.\(UUID().uuidString)")!
        let favoritesService = FavoritesService(defaults: defaults)

        let older = PickupLine(text: "Older", topic: "test", createdAt: Date(timeIntervalSince1970: 1000))
        let newer = PickupLine(text: "Newer", topic: "test", createdAt: Date(timeIntervalSince1970: 2000))

        favoritesService.add(older)
        favoritesService.add(newer)

        let vm = FavoritesViewModel(favoritesService: favoritesService)
        #expect(vm.favorites.first?.text == "Newer")
        #expect(vm.favorites.last?.text == "Older")
    }

    @Test @MainActor func removeFavorite() {
        let defaults = UserDefaults(suiteName: "test.\(UUID().uuidString)")!
        let favoritesService = FavoritesService(defaults: defaults)

        let line1 = PickupLine(text: "Line 1", topic: "test", createdAt: Date(timeIntervalSince1970: 1000))
        let line2 = PickupLine(text: "Line 2", topic: "test", createdAt: Date(timeIntervalSince1970: 2000))

        favoritesService.add(line1)
        favoritesService.add(line2)

        let vm = FavoritesViewModel(favoritesService: favoritesService)
        vm.removeFavorite(line2)

        #expect(favoritesService.favorites.count == 1)
        #expect(favoritesService.favorites.first?.text == "Line 1")
    }
}
