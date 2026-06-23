//
//  UserDefaultsUtil.swift
//  MLBaseTool
//
//  UserDefaults 类型安全读写封装，支持 Codable 对象存储。
//

import Foundation

/// UserDefaults 便捷工具
public struct UserDefaultsUtil {

    private static let defaults = UserDefaults.standard

    /// 存储任意基础类型值
    public static func set<T>(_ value: T?, forKey key: String) {
        defaults.set(value, forKey: key)
    }

    /// 读取字符串
    public static func string(forKey key: String) -> String? {
        return defaults.string(forKey: key)
    }

    /// 读取布尔值
    public static func bool(forKey key: String) -> Bool {
        return defaults.bool(forKey: key)
    }

    /// 读取整型
    public static func integer(forKey key: String) -> Int {
        return defaults.integer(forKey: key)
    }

    /// 读取浮点型
    public static func double(forKey key: String) -> Double {
        return defaults.double(forKey: key)
    }

    /// 删除指定 key
    public static func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }

    /// 存储 Codable 对象
    public static func setCodable<T: Codable>(_ value: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key)
        }
    }

    /// 读取 Codable 对象
    public static func codable<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
