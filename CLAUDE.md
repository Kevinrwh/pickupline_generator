# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

iOS SwiftUI app (iOS 16+) that generates pickup lines using the Anthropic Claude API. The user enters a topic or name, Claude generates 5 lines, and the user can save favorites and copy lines to clipboard. No backend — API key stored in the iOS Keychain.

## Build & Run

Open `PickupLineGenerator/PickupLineGenerator.xcodeproj` in Xcode, select a simulator or device, and press **Cmd+R**. There is no CLI build step.

To run tests: **Cmd+U** in Xcode, or via CLI:
```
xcodebuild test -project PickupLineGenerator/PickupLineGenerator.xcodeproj \
  -scheme PickupLineGenerator -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Architecture

**Pattern**: MVVM, SwiftUI, no third-party dependencies.

**Key data flow**:
1. User enters topic in `GeneratorView` → `GeneratorViewModel.generate()` is called
2. `GeneratorViewModel` reads API key from `KeychainService`, calls `ClaudeAPIService.generatePickupLines(topic:apiKey:)`
3. `ClaudeAPIService` POSTs to `https://api.anthropic.com/v1/messages` using `claude-haiku-4-5-20251001`, parses the response into `[String]`
4. `GeneratorViewModel` maps strings → `[PickupLine]` and publishes to the view
5. Favorites are toggled via `FavoritesService` (shared `ObservableObject`, injected as `.environmentObject`)

**Shared state**: `FavoritesService` is created once as `@StateObject` in `PickupLineGeneratorApp` and injected app-wide. All tabs read/write through this single instance.

**Error handling**: All errors are typed as `AppError` (in `Utilities/AppError.swift`) and surfaced as `@Published var error: AppError?` on each ViewModel. Views display inline banners — no alerts.

## Claude API Integration

- Model: `claude-haiku-4-5-20251001`
- Endpoint: `POST https://api.anthropic.com/v1/messages`
- Required headers: `x-api-key`, `anthropic-version: 2023-06-01`, `content-type: application/json`
- Prompt template: `"Generate 5 creative and clever pickup lines about \(topic). Return only the pickup lines, one per line, numbered 1-5."`
- Response parsing: extract `content[0].text`, split on newlines, strip leading numbering (`1. `, `2. `, etc.)

## Storage

- **API key**: Keychain via `KeychainService` — `kSecClassGenericPassword`, service `com.pickuplinegenerator.apikey`, accessible `kSecAttrAccessibleWhenUnlockedThisDeviceOnly`
- **Favorites**: UserDefaults key `"saved_pickup_lines"` — JSON-encoded `[PickupLine]` array

## Folder Layout

```
PickupLineGenerator/
├── Models/          # PickupLine.swift, ClaudeModels.swift
├── Services/        # KeychainService, ClaudeAPIService, FavoritesService
├── ViewModels/      # GeneratorViewModel, FavoritesViewModel, SettingsViewModel
├── Views/
│   ├── Generator/   # GeneratorView, PickupLineRowView
│   ├── Favorites/   # FavoritesView, FavoriteRowView
│   └── Settings/    # SettingsView
└── Utilities/       # AppError.swift
```
