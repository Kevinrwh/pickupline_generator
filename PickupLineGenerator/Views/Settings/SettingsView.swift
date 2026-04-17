import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showAPIKey = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    if viewModel.hasExistingKey {
                        Label("API key saved", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Button("Remove Key", role: .destructive) {
                            viewModel.clearKey()
                        }
                    }
                    HStack {
                        if showAPIKey {
                            TextField("sk-ant-api...", text: $viewModel.apiKeyInput)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                        } else {
                            SecureField("sk-ant-api...", text: $viewModel.apiKeyInput)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                        }
                        Button {
                            showAPIKey.toggle()
                        } label: {
                            Image(systemName: showAPIKey ? "eye.slash" : "eye")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                    Button(viewModel.isSaved ? "Saved!" : "Save Key") {
                        viewModel.saveKey()
                    }
                    .disabled(viewModel.apiKeyInput.isEmpty)
                } header: {
                    Text("Anthropic API Key")
                } footer: {
                    Text("Your key is stored securely in the iOS Keychain and never leaves your device.")
                }

                if let error = viewModel.error {
                    Section {
                        Text(error.localizedDescription)
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                }

                Section("About") {
                    LabeledContent("Model", value: "claude-haiku-4-5")
                    LabeledContent("Version", value: "1.0.0")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
