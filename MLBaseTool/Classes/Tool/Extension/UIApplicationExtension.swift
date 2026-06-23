//
//  UIApplicationExtension.swift
//  MLBaseTool
//
//  UIApplication 扩展：获取当前 keyWindow。
//

import UIKit

public extension UIApplication {

    /// 获取当前 key window，兼容 iOS 13+ 多 Scene
    static func currentWindow() -> UIWindow? {
        if #available(iOS 15.0, *) {
            return shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else if #available(iOS 13.0, *) {
            return shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .first { $0.isKeyWindow }
        }
        return shared.delegate?.window ?? nil
    }

    @available(*, deprecated, renamed: "currentWindow()")
    static func currentwindow() -> UIWindow? {
        return currentWindow()
    }
}

public extension UIWindow {

    /// 获取当前 key window（与 UIApplication.currentWindow 等价）
    @objc static func ml_keyWindow() -> UIWindow? {
        return UIApplication.currentWindow()
    }

    @available(*, deprecated, renamed: "ml_keyWindow()")
    @objc static func getKeyWindow() -> UIWindow? {
        return ml_keyWindow()
    }
}
