//
//  Config.swift
//  Yoga
//
//  Created by 叫我锅先生 on 2019/3/31.
//  Copyright © 2019 叫我锅先生. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 常量
let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height

///判断是否是iPhone X
let isPhoneX = Bool(ScreenWidth >= 375.0 && ScreenHeight >= 812.0 && isPhone)
///判断是否是iPhone 5s
let isPhone5s = Bool(ScreenWidth <= 320.0 && ScreenHeight <= 568.0 && isPhone)
///判断是否是iPhone
let isPhone = Bool(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
///判断是否是iPad
let isIPad = Bool(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
///导航条的高度
let kNavigationHeight = CGFloat(isPhoneX ? 88 : 64)
///状态栏高度
let kStatusBarHeight = CGFloat(isPhoneX ? 44 : 20)
///tabbar高度
let kTabBarHeight = CGFloat(isPhoneX ? (49 + 34) : 49)

//MARK: - color
///RGBHex
public func kRGBColorFromHex(rgbValue: Int, alpha: CGFloat = 1.0) -> (UIColor) {
    return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
                   alpha: alpha)
}

// MARK: - 字体
public enum Weight {
    case medium
    case semibold
    case light
    case ultralight
    case regular
    case thin
}

/// pingfang-sc 字体
public func Font(_ size: CGFloat) -> UIFont {
    return FontWeight(size, weight: .regular)
}

/// pingfang-sc 字体
public func FontMedium(_ size: CGFloat) -> UIFont {
    return FontWeight(size, weight: .medium)
}

/// pingfang-sc 字体
public func FontBold(_ size: CGFloat) -> UIFont {
    return FontWeight(size, weight: .semibold)
}

/// pingfang-sc 字体
public func FontWeight(_ size: CGFloat, weight: Weight) -> UIFont {
    var name = ""
    switch weight {
    case .medium:
        name = "PingFangSC-Medium"
    case .semibold:
        name = "PingFangSC-Semibold"
    case .light:
        name = "PingFangSC-Light"
    case .ultralight:
        name = "PingFangSC-Ultralight"
    case .regular:
        name = "PingFangSC-Regular"
    case .thin:
        name = "PingFangSC-Thin"
    }
    return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
}

///根据屏幕比例计算字号
public func fontScale<T: BinaryInteger>(_ font: T) -> CGFloat {
    return CGFloat(font) * scale()
}

func scale() -> CGFloat {
    return fmin(ScreenWidth, ScreenHeight) / 375.0
}

// MARK: - App信息
/// App 显示名称
public var AppDisplayName: String? {
    return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
}

public var AppName: String? {
    return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
}

/// app 的bundleid
public var AppBundleID: String? {
    return Bundle.main.bundleIdentifier
}

/// build号
public var AppBuildNumber: String? {
    return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
}

/// app版本号
public var AppVersion: String? {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}

// MARK: - 打印输出
public func GFFLog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\n\n<><><><><>-「LOG」-<><><><><>\n\n>>>>>>>>>>>>>>>所在类:>>>>>>>>>>>>>>>\n\n\(fileName)\n\n>>>>>>>>>>>>>>>所在行:>>>>>>>>>>>>>>>\n\n\(lineNum)\n\n>>>>>>>>>>>>>>>信 息:>>>>>>>>>>>>>>>\n\n\(message)\n\n<><><><><>-「END」-<><><><><>\n\n")
    #endif
}
