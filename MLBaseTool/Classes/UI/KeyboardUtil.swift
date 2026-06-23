//
//  KeyboardUtil.swift
//  MLBaseTool
//
//  键盘处理：点击空白收起键盘、ScrollView 自动避让键盘。
//

import UIKit

/// 键盘工具
public final class KeyboardUtil: NSObject {

    private weak var scrollView: UIScrollView?
    private var originalContentInset: UIEdgeInsets = .zero
    private var originalIndicatorInset: UIEdgeInsets = .zero
    private var tapGesture: UITapGestureRecognizer?

    private static var sharedHandlers = [KeyboardUtil]()

    // MARK: - 点击空白收起键盘

    /// 点击 view 空白区域收起键盘
    public static func enableDismissOnTap(_ view: UIView) {
        let handler = KeyboardUtil()
        let tap = UITapGestureRecognizer(target: handler, action: #selector(handler.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        handler.tapGesture = tap
        sharedHandlers.append(handler)
    }

    @objc private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    // MARK: - ScrollView 避让键盘

    /// 监听键盘，自动调整 ScrollView 的 contentInset
    public static func adjustScrollView(_ scrollView: UIScrollView) {
        let handler = KeyboardUtil()
        handler.scrollView = scrollView
        handler.originalContentInset = scrollView.contentInset
        handler.originalIndicatorInset = scrollView.scrollIndicatorInsets
        NotificationCenter.default.addObserver(
            handler,
            selector: #selector(handler.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            handler,
            selector: #selector(handler.keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        sharedHandlers.append(handler)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let scrollView = scrollView,
              let userInfo = notification.userInfo,
              let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        let keyboardHeight = frame.height
        UIView.animate(withDuration: duration) {
            scrollView.contentInset = UIEdgeInsets(
                top: self.originalContentInset.top,
                left: self.originalContentInset.left,
                bottom: self.originalContentInset.bottom + keyboardHeight,
                right: self.originalContentInset.right
            )
            scrollView.scrollIndicatorInsets = UIEdgeInsets(
                top: self.originalIndicatorInset.top,
                left: self.originalIndicatorInset.left,
                bottom: self.originalIndicatorInset.bottom + keyboardHeight,
                right: self.originalIndicatorInset.right
            )
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let scrollView = scrollView,
              let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        UIView.animate(withDuration: duration) {
            scrollView.contentInset = self.originalContentInset
            scrollView.scrollIndicatorInsets = self.originalIndicatorInset
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
