//
//  FileUtil.swift
//  MLBaseTool
//
//  文件与缓存目录工具：路径获取、大小计算、清理缓存。
//

import Foundation

/// 文件与缓存工具
public struct FileUtil {

    private static let fileManager = FileManager.default

    /// Documents 目录路径
    public static var documentsPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    }

    /// Library/Caches 目录路径
    public static var cachesPath: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
    }

    /// tmp 目录路径
    public static var tmpPath: String {
        return NSTemporaryDirectory()
    }

    /// 缓存目录总大小（字节）
    public static func cacheSize() -> UInt64 {
        return folderSize(at: cachesPath)
    }

    /// 格式化缓存大小，如 "12.5 MB"
    public static func cacheSizeString() -> String {
        return formatBytes(cacheSize())
    }

    /// 清空 Caches 目录
    @discardableResult
    public static func clearCache() -> Bool {
        return clearFolder(at: cachesPath)
    }

    /// 清空 tmp 目录
    @discardableResult
    public static func clearTmp() -> Bool {
        return clearFolder(at: tmpPath)
    }

    /// 计算文件夹大小
    public static func folderSize(at path: String) -> UInt64 {
        guard fileManager.fileExists(atPath: path) else { return 0 }
        guard let enumerator = fileManager.enumerator(atPath: path) else { return 0 }
        var size: UInt64 = 0
        for case let fileName as String in enumerator {
            let fullPath = (path as NSString).appendingPathComponent(fileName)
            if let attrs = try? fileManager.attributesOfItem(atPath: fullPath),
               let fileSize = attrs[.size] as? UInt64 {
                size += fileSize
            }
        }
        return size
    }

    /// 字节数转可读字符串
    public static func formatBytes(_ bytes: UInt64) -> String {
        let kb = Double(bytes) / 1024
        if kb < 1024 { return String(format: "%.1f KB", kb) }
        let mb = kb / 1024
        if mb < 1024 { return String(format: "%.1f MB", mb) }
        return String(format: "%.2f GB", mb / 1024)
    }

    @discardableResult
    private static func clearFolder(at path: String) -> Bool {
        guard fileManager.fileExists(atPath: path) else { return true }
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: path)
            for item in contents {
                let fullPath = (path as NSString).appendingPathComponent(item)
                try fileManager.removeItem(atPath: fullPath)
            }
            return true
        } catch {
            MLLog("clearFolder error: \(error)")
            return false
        }
    }
}
