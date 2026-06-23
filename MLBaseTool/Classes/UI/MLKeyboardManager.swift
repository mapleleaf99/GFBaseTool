//
//  MLKeyboardManager.swift
//  MLBaseTool
//
//  弹窗场景下的键盘管理：自动上移包含输入框的视图，避免被键盘遮挡。
//

import UIKit

/// 弹窗键盘管理器（配合 MLAlertObject.autoKeyboardManager 使用）
public class MLKeyboardManager: NSObject {

    public static let shared = MLKeyboardManager()

    private var keyboardFrame: CGRect?
    private weak var nowInputView: UIView?

    /// 是否启用
    public var enable: Bool = false {
        didSet {
            if enable {
                setupNotification()
            } else {
                removeNotification()
            }
        }
    }

    /// 输入框与键盘间距
    public var keyboardDistanceFromTextField: CGFloat = 20

    private override init() {
        super.init()
    }

    deinit {
        removeNotification()
    }

    private func setupNotification() {
        removeNotification()
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(textFieldDidBeginEditing(_:)), name: UITextField.textDidBeginEditingNotification, object: nil)
        center.addObserver(self, selector: #selector(textViewDidBeginEditing(_:)), name: UITextView.textDidBeginEditingNotification, object: nil)
    }

    private func removeNotification() {
        if let inputView = nowInputView, let view = getViewInWindow(view: inputView) {
            UIView.animate(withDuration: 0.25) {
                view.transform = .identity
            }
        }
        NotificationCenter.default.removeObserver(self)
        nowInputView = nil
        keyboardFrame = nil
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let inputView = nowInputView else { return }
        keyboardFrame = keyboardSize
        adjustInputViewPosition(inputView: inputView, keyboardFrame: keyboardSize)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        if let inputView = nowInputView, let view = getViewInWindow(view: inputView) {
            UIView.animate(withDuration: 0.25) {
                view.transform = .identity
            }
        }
    }

    @objc private func textFieldDidBeginEditing(_ notification: Notification) {
        guard let textField = notification.object as? UITextField else { return }
        resetPreviousInputIfNeeded(newInput: textField)
        nowInputView = textField
        if let keyboardFrame = keyboardFrame {
            adjustInputViewPosition(inputView: textField, keyboardFrame: keyboardFrame)
        }
    }

    @objc private func textViewDidBeginEditing(_ notification: Notification) {
        guard let textView = notification.object as? UITextView else { return }
        resetPreviousInputIfNeeded(newInput: textView)
        nowInputView = textView
        if let keyboardFrame = keyboardFrame {
            adjustInputViewPosition(inputView: textView, keyboardFrame: keyboardFrame)
        }
    }

    private func resetPreviousInputIfNeeded(newInput: UIView) {
        if let old = nowInputView, old !== newInput, let oldView = getViewInWindow(view: old) {
            oldView.transform = .identity
        }
    }

    private func adjustInputViewPosition(inputView: UIView, keyboardFrame: CGRect) {
        guard let view = getViewInWindow(view: inputView),
              let window = UIWindow.ml_keyWindow() else { return }

        let inputFrame = inputView.superview?.convert(inputView.frame, to: window) ?? .zero
        let containerFrame = view.superview?.convert(view.frame, to: window) ?? .zero
        let inputBottom = inputFrame.maxY
        let keyboardTop = keyboardFrame.origin.y
        let offset = keyboardTop - inputBottom - keyboardDistanceFromTextField

        if offset < 0 {
            UIView.animate(withDuration: 0.25) {
                view.transform = CGAffineTransform(translationX: 0, y: containerFrame.origin.y + offset)
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                view.transform = .identity
            }
        }
    }

    /// 获取输入框所在的弹窗根视图（非 ViewController 层级）
    public func getViewInWindow(view: UIView?) -> UIView? {
        guard let view = view else { return nil }
        var next: UIResponder? = view
        while let responder = next {
            if responder is UIWindow { return responder as? UIView }
            if responder is UIViewController { return nil }
            next = responder.next
        }
        return nil
    }
}
