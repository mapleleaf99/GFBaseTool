//
//  Config.swift
//  MLBaseTool
//
//  全局常量与便捷方法：屏幕尺寸、安全区、颜色、字体、App 信息、调试日志。
//

import Foundation
import UIKit

// MARK: - 屏幕常量

/// 屏幕宽度（pt）
public let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width

/// 屏幕高度（pt）
public let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height

/// 是否为 iPhone
public var isPhone: Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}

/// 是否为 iPad
public var isIPad: Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}

/// 是否为 iPhone 5s 及以下小屏机型
public var isPhone5s: Bool {
    return ScreenWidth <= 320.0 && ScreenHeight <= 568.0 && isPhone
}

/// 是否为全面屏设备（通过底部安全区判断）
public var isPhoneX: Bool {
    return safeAreaBottom > 0
}

/// 顶部安全区高度（状态栏区域）
public var safeAreaTop: CGFloat {
    let inset = UIApplication.currentWindow()?.safeAreaInsets.top ?? 0
    return inset > 0 ? inset : (isPhone ? 20 : 0)
}

/// 底部安全区高度（Home Indicator 区域）
public var safeAreaBottom: CGFloat {
    return UIApplication.currentWindow()?.safeAreaInsets.bottom ?? 0
}

/// 状态栏高度，等价于 safeAreaTop
public var kStatusBarHeight: CGFloat {
    return safeAreaTop
}

/// 导航栏总高度 = 状态栏 + 44
public var kNavigationHeight: CGFloat {
    return safeAreaTop + 44
}

/// TabBar 总高度 = 49 + 底部安全区
public var kTabBarHeight: CGFloat {
    return 49 + safeAreaBottom
}

// MARK: - 颜色

/// 通过 0xRRGGBB 整型值创建颜色
/// - Parameters:
///   - rgbValue: 十六进制颜色值，如 0xFF5500
///   - alpha: 透明度，默认 1.0
public func kRGBColorFromHex(rgbValue: Int, alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0xFF) / 255.0,
        alpha: alpha
    )
}

/// 通过 0~255 的 RGB 分量创建颜色
public func kRGBColor(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
}

// MARK: - 字体

/// 苹方字体字重枚举
public enum Weight {
    case medium
    case semibold
    case light
    case ultralight
    case regular
    case thin
}

/// 苹方 Regular 字体
public func Font(_ size: CGFloat) -> UIFont {
    return FontWeight(size, weight: .regular)
}

/// 苹方 Medium 字体
public func FontMedium(_ size: CGFloat) -> UIFont {
    return FontWeight(size, weight: .medium)
}

/// 苹方 Semibold 字体（常用于粗体标题）
public func FontBold(_ size: CGFloat) -> UIFont {
    return FontWeight(size, weight: .semibold)
}

/// 按字重获取苹方字体，找不到时回退系统字体
public func FontWeight(_ size: CGFloat, weight: Weight) -> UIFont {
    let name: String
    switch weight {
    case .medium: name = "PingFangSC-Medium"
    case .semibold: name = "PingFangSC-Semibold"
    case .light: name = "PingFangSC-Light"
    case .ultralight: name = "PingFangSC-Ultralight"
    case .regular: name = "PingFangSC-Regular"
    case .thin: name = "PingFangSC-Thin"
    }
    return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
}

/// 按屏幕宽度等比缩放字号（基准屏宽 375）
public func fontScale<T: BinaryInteger>(_ font: T) -> CGFloat {
    return CGFloat(font) * scale()
}

/// 屏幕缩放比例，以 375pt 宽度为基准
public func scale() -> CGFloat {
    return fmin(ScreenWidth, ScreenHeight) / 375.0
}

// MARK: - App 信息

/// App 显示名称（桌面图标下方名称）
public var AppDisplayName: String? {
    return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
}

/// App Bundle 名称
public var AppName: String? {
    return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
}

/// App Bundle Identifier
public var AppBundleID: String? {
    return Bundle.main.bundleIdentifier
}

/// App Build 号
public var AppBuildNumber: String? {
    return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
}

/// App 版本号（对外显示）
public var AppVersion: String? {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}

// MARK: - 日志

/// Debug 模式下的格式化日志输出
public func MLLog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("[MLBaseTool] \(fileName):\(lineNum) \(funcName) -> \(message)")
    #endif
}
