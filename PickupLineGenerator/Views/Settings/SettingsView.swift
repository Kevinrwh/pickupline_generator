import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showAPIKey = false
    @State private var isReplacingKey = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    if viewModel.hasExistingKey && !isReplacingKey {
                        Label("API key saved", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)

                        Button("Replace Key") {
                            isReplacingKey = true
                        }

                        Button("Remove Key", role: .destructive) {
                            viewModel.clearKey()
                            isReplacingKey = false
                        }
                    } else {
                        apiKeyInput
                    }
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
                    LabeledContent("Created by", value: "Kevin Ramos")
                    LabeledContent("Version", value: "1.0.0")
                }
            }
            .navigationTitle("Settings")
        }
    }

    private var apiKeyInput: some View {
        Group {
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
                isReplacingKey = false
            }
            .disabled(viewModel.apiKeyInput.isEmpty)

            if isReplacingKey {
                Button("Cancel", role: .cancel) {
                    viewModel.apiKeyInput = ""
                    isReplacingKey = false
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
