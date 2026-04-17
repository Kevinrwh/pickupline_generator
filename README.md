# Pickup Line Generator

An iOS app that generates pickup lines using the Claude AI API. Enter a topic or name, get 5 creative lines back, save your favorites, and copy them straight to the clipboard.

## Features

- **AI-generated lines** — powered by Claude (claude-haiku-4-5-20251001)
- **Save favorites** — persisted locally across sessions
- **Copy to clipboard** — one tap to paste into any dating app
- **Secure key storage** — your Anthropic API key lives in the iOS Keychain

## Requirements

- Xcode 15+
- iOS 16+ device or simulator
- An [Anthropic API key](https://console.anthropic.com/)

## Getting Started

### 1. Generate the Xcode project

Install [xcodegen](https://github.com/yonaskolb/XcodeGen) if you haven't already:

```bash
brew install xcodegen
```

Then from the repo root:

```bash
xcodegen generate
```

This creates `PickupLineGenerator.xcodeproj`.

### 2. Open in Xcode

```bash
open PickupLineGenerator.xcodeproj
```

### 3. Run the app

Select a simulator (or your device) and press **Cmd+R**.

On first launch, go to the **Settings** tab and paste in your Anthropic API key. It's stored securely in the Keychain and never leaves your device.

## Project Structure

```
PickupLineGenerator/
├── Models/          # PickupLine, Claude API request/response structs
├── Services/        # KeychainService, ClaudeAPIService, FavoritesService
├── ViewModels/      # GeneratorViewModel, FavoritesViewModel, SettingsViewModel
├── Views/
│   ├── Generator/   # Main generation screen
│   ├── Favorites/   # Saved favorites screen
│   └── Settings/    # API key management
└── Utilities/       # AppError
```

## Development

After adding new `.swift` files, re-run `xcodegen generate` to include them in the project — no need to manually add files in Xcode.
