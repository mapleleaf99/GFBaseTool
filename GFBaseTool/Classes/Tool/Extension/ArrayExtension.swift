//
//  ArrayExtension.swift
//  GFBaseTool
//
//  Array / Dictionary 扩展：安全下标、JSON 字符串。
//

import Foundation

public extension Array {
    /// 安全下标，越界时返回 nil 而不是崩溃
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Dictionary {
    /// 将字典序列化为 JSON 字符串
    func jsonString(prettyPrinted: Bool = false) -> String? {
        let options: JSONSerialization.WritingOptions = prettyPrinted ? .prettyPrinted : []
        guard JSONSerialization.isValidJSONObject(self),
              let data = try? JSONSerialization.data(withJSONObject: self, options: options) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
