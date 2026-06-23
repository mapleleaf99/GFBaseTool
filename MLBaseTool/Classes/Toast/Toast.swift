//
//  Toast.swift
//  MLBaseTool
//
//  Toast 提示封装，基于 Toast-Swift，自动获取当前 window 显示。
//

import UIKit
import Toast_Swift

/// Toast 提示工具
public class Toast: NSObject {

    /// 显示文字提示
    /// - Parameters:
    ///   - message: 提示内容
    ///   - position: 显示位置，默认居中
    public static func show(_ message: String?, position: ToastPosition = .center) {
        UIApplication.currentWindow()?.makeToast(message, position: position)
    }

    /// 隐藏文字提示
    public static func hidden() {
        UIApplication.currentWindow()?.hideToast()
    }

    /// 显示 Loading 菊花
    public static func showProgress(_ position: ToastPosition = .center) {
        UIApplication.currentWindow()?.makeToastActivity(position)
    }

    /// 隐藏 Loading 菊花
    public static func hiddenProgress() {
        UIApplication.currentWindow()?.hideToastActivity()
    }
}
