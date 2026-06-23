//
//  NSAttributedString+MLAttributed.swift
//  MLBaseTool
//
//  富文本尺寸计算、关键词高亮、HTML 解析、快速拼接。
//

import UIKit

public extension NSAttributedString {

    /// 固定高度计算宽度
    func ml_width(maxHeight: CGFloat) -> CGFloat {
        return ml_size(maxWidth: .greatestFiniteMagnitude, maxHeight: maxHeight).width
    }

    /// 固定宽度计算高度
    func ml_height(maxWidth: CGFloat) -> CGFloat {
        return ml_size(maxWidth: maxWidth, maxHeight: .greatestFiniteMagnitude).height
    }

    /// 计算 bounding size
    func ml_size(maxWidth: CGFloat, maxHeight: CGFloat) -> CGSize {
        return boundingRect(
            with: CGSize(width: maxWidth, height: maxHeight),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        ).size
    }
}

public extension NSMutableAttributedString {

    /// 创建带字体颜色的富文本
    static func ml_text(
        _ text: String,
        color: UIColor = UIColor(white: 0.2, alpha: 1),
        font: UIFont = Font(14)
    ) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: (text as NSString).length)
        attr.addAttributes([.font: font, .foregroundColor: color], range: range)
        return attr
    }

    /// 追加一段富文本
    @discardableResult
    func ml_append(
        _ text: String,
        color: UIColor = UIColor(white: 0.2, alpha: 1),
        font: UIFont = Font(14),
        lineSpacing: CGFloat = 0,
        textAlignment: NSTextAlignment = .left
    ) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString.ml_text(text, color: color, font: font)
        if lineSpacing > 0 || textAlignment != .left {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            style.alignment = textAlignment
            attr.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: attr.length))
        }
        append(attr)
        return self
    }

    /// 设置全文行间距与对齐
    func ml_setLineSpacing(_ lineSpacing: CGFloat, textAlignment: NSTextAlignment = .left) {
        guard length > 0 else { return }
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = textAlignment
        addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: length))
    }

    /// 高亮第一个关键词
    @discardableResult
    func ml_highlight(
        keyword: String,
        color: UIColor,
        options: String.CompareOptions = [.caseInsensitive]
    ) -> NSMutableAttributedString {
        let text = string
        guard let range = text.range(of: keyword, options: options),
              let nsRange = text.ml_toNSRange(from: range) else { return self }
        addAttribute(.foregroundColor, value: color, range: nsRange)
        return self
    }

    /// 高亮所有关键词
    @discardableResult
    func ml_highlight(
        keywords: [String],
        color: UIColor,
        options: String.CompareOptions = [.caseInsensitive]
    ) -> NSMutableAttributedString {
        for keyword in keywords where !keyword.isEmpty {
            string.ml_keywordRanges(keyword, options: options).forEach {
                addAttribute(.foregroundColor, value: color, range: $0)
            }
        }
        return self
    }

    /// 蓝色下划线链接样式文本
    static func ml_linkStyle(_ content: String, color: UIColor? = nil) -> NSMutableAttributedString {
        let linkColor = color ?? UIColor(red: 0, green: 122 / 255, blue: 254 / 255, alpha: 1)
        return content.ml_makeAttributed { make in
            make.foregroundColor(linkColor)
                .underlineStyle(.single)
                .allRange()
        }
    }

    /// HTML 转富文本
    static func ml_fromHTML(_ html: String, fontSize: CGFloat = 14) -> NSMutableAttributedString? {
        let htmlString = html.replacingOccurrences(of: "\n", with: "<br>")
        guard let data = htmlString.data(using: .utf8) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let attr = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        attr.enumerateAttribute(.font, in: NSRange(location: 0, length: attr.length)) { value, range, _ in
            guard let originalFont = value as? UIFont else { return }
            let updated = UIFont(name: originalFont.fontName, size: fontSize) ?? Font(fontSize)
            attr.addAttribute(.font, value: updated, range: range)
        }
        return attr
    }
}
