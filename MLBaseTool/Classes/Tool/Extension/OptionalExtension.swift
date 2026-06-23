//
//  OptionalExtension.swift
//  MLBaseTool
//
//  Optional 扩展：空值判断、默认值。
//

import Foundation

public extension Optional where Wrapped == String {
    /// 是否为 nil 或空字符串
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

public extension Optional {
    /// 为 nil 时返回默认值
    func or(_ defaultValue: Wrapped) -> Wrapped {
        return self ?? defaultValue
    }
}
