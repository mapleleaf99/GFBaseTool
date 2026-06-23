//
//  MLAttributedMaker.swift
//  MLBaseTool
//
//  链式富文本构建器。
//

import UIKit

/// 链式富文本构建器
public class MLAttributedMaker: NSObject {

    private var strings: [String] = []
    private var paragraphStyle: NSMutableParagraphStyle?
    private var attributedItems: [NSAttributedString.Key: Any] = [:]
    private var attributedStrings: [NSMutableAttributedString] = []

    public override init() {
        super.init()
    }

    public convenience init(string: String) {
        self.init()
        strings.append(string)
        attributedStrings.append(NSMutableAttributedString(string: string))
    }

    /// 构建结果
    public func result() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedStrings.forEach { attributedString.append($0) }
        return attributedString
    }

    // MARK: - 属性设置

    @discardableResult
    public func font(_ value: UIFont) -> MLAttributedMaker {
        addAttributed(.font, value: value)
        return self
    }

    @discardableResult
    public func italic(_ value: CGFloat) -> MLAttributedMaker {
        addAttributed(.obliqueness, value: value)
        return self
    }

    @discardableResult
    public func foregroundColor(_ value: UIColor) -> MLAttributedMaker {
        addAttributed(.foregroundColor, value: value)
        return self
    }

    @discardableResult
    public func backgroundColor(_ value: UIColor) -> MLAttributedMaker {
        addAttributed(.backgroundColor, value: value)
        return self
    }

    @discardableResult
    public func strikethroughStyle(_ value: NSUnderlineStyle = .single) -> MLAttributedMaker {
        addAttributed(.strikethroughStyle, value: value.rawValue)
        return self
    }

    @discardableResult
    public func strikethroughColor(_ value: UIColor) -> MLAttributedMaker {
        addAttributed(.strikethroughColor, value: value)
        return self
    }

    @discardableResult
    public func underlineStyle(_ value: NSUnderlineStyle) -> MLAttributedMaker {
        addAttributed(.underlineStyle, value: value.rawValue)
        return self
    }

    @discardableResult
    public func underlineColor(_ value: UIColor) -> MLAttributedMaker {
        addAttributed(.underlineColor, value: value)
        return self
    }

    @discardableResult
    public func strokeWidth(_ value: CGFloat) -> MLAttributedMaker {
        addAttributed(.strokeWidth, value: value)
        return self
    }

    @discardableResult
    public func strokeColor(_ value: UIColor) -> MLAttributedMaker {
        addAttributed(.strokeColor, value: value)
        return self
    }

    @discardableResult
    public func shadow(_ value: NSShadow) -> MLAttributedMaker {
        addAttributed(.shadow, value: value)
        return self
    }

    @discardableResult
    public func kern(_ value: CGFloat) -> MLAttributedMaker {
        addAttributed(.kern, value: value)
        return self
    }

    @discardableResult
    public func lineSpacing(_ value: CGFloat) -> MLAttributedMaker {
        ensureParagraphStyle()
        paragraphStyle?.lineSpacing = value
        addAttributed(.paragraphStyle, value: paragraphStyle)
        return self
    }

    @discardableResult
    public func paragraphSpacing(_ value: CGFloat) -> MLAttributedMaker {
        ensureParagraphStyle()
        paragraphStyle?.paragraphSpacing = value
        addAttributed(.paragraphStyle, value: paragraphStyle)
        return self
    }

    @discardableResult
    public func lineBreakMode(_ value: NSLineBreakMode) -> MLAttributedMaker {
        ensureParagraphStyle()
        paragraphStyle?.lineBreakMode = value
        addAttributed(.paragraphStyle, value: paragraphStyle)
        return self
    }

    @discardableResult
    public func textAlignment(_ value: NSTextAlignment) -> MLAttributedMaker {
        ensureParagraphStyle()
        paragraphStyle?.alignment = value
        addAttributed(.paragraphStyle, value: paragraphStyle)
        return self
    }

    /// 设置 URL（UITextView 有效）
    @discardableResult
    public func link(_ value: String) -> MLAttributedMaker {
        if let url = URL(string: value) {
            addAttributed(.link, value: url)
        }
        return self
    }

    // MARK: - 图片

    @discardableResult
    public func insertLeadImage(_ image: UIImage?, _ bounds: CGRect) -> MLAttributedMaker {
        guard let image = image, let attributedString = attributedStrings.last else { return self }
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = bounds
        attributedString.insert(NSAttributedString(attachment: attachment), at: 0)
        if let index = attributedStrings.indices.last {
            attributedStrings[index] = attributedString
        }
        return self
    }

    @discardableResult
    public func insertTrailImage(_ image: UIImage?, _ bounds: CGRect) -> MLAttributedMaker {
        guard let image = image, let attributedString = attributedStrings.last else { return self }
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = bounds
        attributedString.append(NSAttributedString(attachment: attachment))
        if let index = attributedStrings.indices.last {
            attributedStrings[index] = attributedString
        }
        return self
    }

    @discardableResult
    public func insertImage(_ image: UIImage?, _ bounds: CGRect, at index: Int = 0) -> MLAttributedMaker {
        guard let image = image, let attributedString = attributedStrings.last else { return self }
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = bounds
        attributedString.insert(NSAttributedString(attachment: attachment), at: index)
        return self
    }

    // MARK: - 拼接

    @discardableResult
    public func appendString(_ string: String) -> MLAttributedMaker {
        strings.append(string)
        attributedStrings.append(NSMutableAttributedString(string: string))
        return self
    }

    @discardableResult
    public func mergeStrings() -> MLAttributedMaker {
        let merged = strings.joined()
        strings = [merged]
        let attributedString = NSMutableAttributedString()
        attributedStrings.forEach { attributedString.append($0) }
        attributedStrings = [attributedString]
        return self
    }

    // MARK: - Range

    public func allRange() {
        if let string = strings.last {
            invokingAttributed(range: NSRange(location: 0, length: (string as NSString).length))
        }
    }

    public func inRange(_ loc: Int, _ len: Int) {
        invokingAttributed(range: NSRange(location: loc, length: len))
    }

    public func inRange(_ range: NSRange) {
        invokingAttributed(range: range)
    }

    public func inRange(of value: String, options mask: String.CompareOptions = []) {
        guard let string = strings.last,
              let range = string.range(of: value, options: mask),
              let nsRange = string.ml_toNSRange(from: range) else { return }
        invokingAttributed(range: nsRange)
    }

    public func inRanges(of value: String) {
        guard let string = attributedStrings.last?.string else { return }
        invokingAttributed(ranges: string.ml_ranges(of: value))
    }

    public func inRanges(of ranges: [Range<String.Index>]) {
        invokingAttributed(ranges: ranges)
    }

    // MARK: - Private

    private func ensureParagraphStyle() {
        if paragraphStyle == nil {
            paragraphStyle = NSMutableParagraphStyle()
        }
    }

    private func addAttributed(_ key: NSAttributedString.Key?, value: Any?) {
        guard let key = key, let value = value else { return }
        attributedItems[key] = value
    }

    private func invokingAttributed(range: NSRange) {
        attributedStrings.last?.addAttributes(attributedItems, range: range)
        resetAttributeRecord()
    }

    private func invokingAttributed(ranges: [Range<String.Index>]) {
        let attributedString = attributedStrings.last
        for range in ranges {
            if let nsRange = attributedString?.string.ml_toNSRange(from: range) {
                attributedString?.addAttributes(attributedItems, range: nsRange)
            }
        }
        resetAttributeRecord()
    }

    private func resetAttributeRecord() {
        attributedItems.removeAll()
        paragraphStyle = nil
    }
}
