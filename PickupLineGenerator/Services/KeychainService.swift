import Foundation
import Security

enum KeychainService {
    private static let service = "com.pickuplinegenerator.apikey"
    private static let account = "anthropic_api_key"

    private static var baseQuery: [CFString: Any] {
        [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ]
    }

    static func save(apiKey: String) throws {
        guard let data = apiKey.data(using: .utf8) else {
            throw AppError.keychainError("Failed to encode API key")
        }

        // Delete any existing item first (ignore not-found errors)
        SecItemDelete(baseQuery as CFDictionary)

        var query = baseQuery
        query[kSecValueData] = data
        query[kSecAttrAccessible] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw AppError.keychainError("Save failed with status \(status)")
        }
    }

    static func retrieve() throws -> String {
        var query = baseQuery
        query[kSecReturnData] = true
        query[kSecMatchLimit] = kSecMatchLimitOne

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecItemNotFound {
            throw AppError.noAPIKey
        }
        guard status == errSecSuccess else {
            throw AppError.keychainError("Retrieve failed with status \(status)")
        }
        guard let data = result as? Data, let key = String(data: data, encoding: .utf8) else {
            throw AppError.keychainError("Failed to decode stored API key")
        }
        return key
    }

    static func delete() throws {
        let status = SecItemDelete(baseQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw AppError.keychainError("Delete failed with status \(status)")
        }
    }
}
