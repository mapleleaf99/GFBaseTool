//
//  KeychainUtil.swift
//  MLBaseTool
//
//  Keychain 安全存储，适用于 Token、密码等敏感信息。
//

import Foundation
import Security

/// Keychain 读写工具
public struct KeychainUtil {

    private static var defaultService: String {
        return Bundle.main.bundleIdentifier ?? "MLBaseTool"
    }

    /// 保存字符串
    @discardableResult
    public static func save(_ value: String, forKey key: String, service: String? = nil) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        return save(data, forKey: key, service: service)
    }

    /// 保存 Data
    @discardableResult
    public static func save(_ data: Data, forKey key: String, service: String? = nil) -> Bool {
        let svc = service ?? defaultService
        delete(forKey: key, service: service)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: svc,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }

    /// 读取字符串
    public static func string(forKey key: String, service: String? = nil) -> String? {
        guard let data = data(forKey: key, service: service) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// 读取 Data
    public static func data(forKey key: String, service: String? = nil) -> Data? {
        let svc = service ?? defaultService
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: svc,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else { return nil }
        return result as? Data
    }

    /// 删除指定 key
    @discardableResult
    public static func delete(forKey key: String, service: String? = nil) -> Bool {
        let svc = service ?? defaultService
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: svc,
            kSecAttrAccount as String: key
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    /// 清空当前 service 下所有数据
    @discardableResult
    public static func clear(service: String? = nil) -> Bool {
        let svc = service ?? defaultService
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: svc
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
