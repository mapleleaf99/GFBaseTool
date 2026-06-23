//
//  AppUtil.swift
//  MLBaseTool
//
//  应用级通用工具：打开 URL、系统设置等。
//

import UIKit

public enum AppUtil {

    /// 打开 URL
    @discardableResult
    public static func openURL(_ url: URL) -> Bool {
        guard UIApplication.shared.canOpenURL(url) else { return false }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        return true
    }

    /// 打开 URL 字符串
    @discardableResult
    public static func openURLString(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return openURL(url)
    }

    /// 打开系统设置
    @discardableResult
    public static func openSettings() -> Bool {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return false }
        return openURL(url)
    }

    /// 是否可打开指定 scheme
    public static func canOpenScheme(_ scheme: String) -> Bool {
        guard let url = URL(string: "\(scheme)://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    /// 复制文本到剪贴板
    public static func copyToPasteboard(_ text: String?) {
        UIPasteboard.general.string = text
    }
}
