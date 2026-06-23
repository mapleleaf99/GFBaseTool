//
//  String+MLAttributed.swift
//  MLBaseTool
//
//  富文本链式构建、Range 工具。
//

import Foundation
import UIKit

public extension String {

    /// 链式构建富文本
    func ml_makeAttributed(_ closure: (MLAttributedMaker) -> Void) -> NSMutableAttributedString {
        if isEmpty { return NSMutableAttributedString(string: "") }
        let maker = MLAttributedMaker(string: self)
        closure(maker)
        return maker.result()
    }

    /// Range 转 NSRange
    func ml_toNSRange(from range: Range<String.Index>) -> NSRange? {
        return NSRange(range, in: self)
    }

    /// NSRange 转 Range
    func ml_toRange(from nsRange: NSRange) -> Range<String.Index>? {
        return Range(nsRange, in: self)
    }

    /// 获取子串所有 Range
    func ml_ranges(of substring: String) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        if #available(iOS 16.0, *) {
            return Array(self.ranges(of: substring))
        }
        var startIndex = self.startIndex
        while let range = self[startIndex...].range(of: substring) {
            ranges.append(range)
            startIndex = range.upperBound
        }
        return ranges
    }

    /// 正则匹配所有 Range
    func ml_ranges(matching pattern: String, options: NSRegularExpression.Options = []) -> [Range<String.Index>] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else { return [] }
        let nsRange = NSRange(startIndex..., in: self)
        return regex.matches(in: self, range: nsRange).compactMap { Range($0.range, in: self) }
    }

    /// 正则匹配所有 NSRange
    func ml_nsRanges(matching pattern: String, options: NSRegularExpression.Options = []) -> [NSRange] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else { return [] }
        let nsRange = NSRange(startIndex..., in: self)
        return regex.matches(in: self, range: nsRange).map { $0.range }
    }

    /// 关键词所有 NSRange（大小写不敏感）
    func ml_keywordRanges(_ keyword: String, options: String.CompareOptions = [.caseInsensitive]) -> [NSRange] {
        guard !isEmpty, !keyword.isEmpty else { return [] }
        var ranges: [NSRange] = []
        var searchStart = startIndex
        while searchStart < endIndex, let found = self[searchStart...].range(of: keyword, options: options) {
            ranges.append(NSRange(found, in: self))
            searchStart = found.upperBound
        }
        return ranges
    }
}

public extension NSString {

    @objc func ml_makeAttributed(_ block: (MLAttributedMaker) -> Void) -> NSMutableAttributedString {
        return (self as String).ml_makeAttributed(block)
    }
}
