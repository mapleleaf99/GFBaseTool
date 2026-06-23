//
//  StringExtension.swift
//  MLBaseTool
//
//  String 扩展：国际化、尺寸计算、类名反射、格式校验。
//

import Foundation
import UIKit

public extension String {

    /// 本地化字符串
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    /// 是否为空白字符串（含纯空格、换行）
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// 计算文本在指定高度下的宽度
    func ml_widthForComment(font: UIFont, height: CGFloat = 15) -> CGFloat {
        let rect = (self as NSString).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        return ceil(rect.width)
    }

    /// 计算文本在指定宽度下的高度
    func ml_heightForComment(font: UIFont, width: CGFloat = UIScreen.main.bounds.width) -> CGFloat {
        let rect = (self as NSString).boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        return ceil(rect.height)
    }

    /// 根据富文本属性计算高度
    func ml_heightForComment(attributes: [NSAttributedString.Key: Any], width: CGFloat = UIScreen.main.bounds.width) -> CGFloat {
        let rect = (self as NSString).boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        return ceil(rect.height)
    }

    /// 根据类名字符串获取 Class（支持 Swift 模块名前缀）
    func getClassFromString() -> AnyClass? {
        guard let spaceName = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            MLLog("获取命名空间失败")
            return nil
        }
        if contains(spaceName) {
            return NSClassFromString(self)
        }
        return NSClassFromString(spaceName + "." + self)
    }

    // MARK: - 格式校验

    /// 正则匹配校验
    func isValid(regex: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }

    /// 是否为大陆手机号（11 位，1 开头）
    var isPhoneNumber: Bool {
        return isValid(regex: "^1[3-9]\\d{9}$")
    }

    /// 是否为邮箱地址
    var isEmail: Bool {
        return isValid(regex: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")
    }

    /// 是否为合法 URL
    var isURL: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }

    /// 是否为 18 位身份证号
    var isIDCard: Bool {
        return isValid(regex: "^[1-9]\\d{5}(18|19|20)\\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\\d|3[01])\\d{3}[\\dXx]$")
    }

    // MARK: - 日期与编码

    /// 字符串转 Date
    func ml_toDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: self)
    }

    /// URL 编码
    func ml_urlEncoding() -> String {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }

    /// 生成随机字符串
    static func ml_randomString(length: Int) -> String {
        let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in chars.randomElement() })
    }
}
