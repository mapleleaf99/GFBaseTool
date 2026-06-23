//
//  UIColorExtension.swift
//  MLBaseTool
//
//  UIColor 扩展：十六进制字符串与 UIColor 互转。
//

import UIKit

public extension UIColor {

    /// 通过十六进制字符串创建颜色
    /// 支持格式：#RGB、#RRGGBB、#AARRGGBB
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") { hexString.removeFirst() }
        if hexString.hasPrefix("0X") { hexString.removeFirst(2) }

        var rgbValue: UInt64 = 0
        guard Scanner(string: hexString).scanHexInt64(&rgbValue) else { return nil }

        let r, g, b, a: CGFloat
        switch hexString.count {
        case 3:
            r = CGFloat((rgbValue & 0xF00) >> 8) / 15.0
            g = CGFloat((rgbValue & 0x0F0) >> 4) / 15.0
            b = CGFloat(rgbValue & 0x00F) / 15.0
            a = alpha
        case 6:
            r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgbValue & 0x0000FF) / 255.0
            a = alpha
        case 8:
            a = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            r = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            g = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            b = CGFloat(rgbValue & 0x000000FF) / 255.0
        default:
            return nil
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }

    /// 转为 #RRGGBB 格式字符串
    var hexString: String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
