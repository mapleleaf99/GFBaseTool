//
//  MLTextField.swift
//  MLBaseTool
//
//  自定义输入框：占位符颜色、左边距、字数限制、Block 回调。
//

import UIKit

/// 增强型 UITextField
public class MLTextField: UITextField {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }

    public override var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        _ = ml_leftView
        updatePlaceholder()
    }

    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "placeholderColor" {
            placeholderColor = value as? UIColor
        }
        if key == "leftMargin", let margin = value as? CGFloat {
            leftMargin = margin
        }
    }

    public override func deleteBackward() {
        super.deleteBackward()
        deleteKeyPressBlock?(self)
    }

    public func deleteKeyPress(_ block: ((_ textfield: MLTextField) -> Void)?) {
        deleteKeyPressBlock = block
    }

    public func pressReturn(_ block: ((_ textfield: MLTextField) -> Void)?) {
        returnBlock = block
    }

    public func beginEditing(_ block: ((_ textfield: MLTextField) -> Void)?) {
        beginBlock = block
    }

    public func endEditing(_ block: ((_ textfield: MLTextField) -> Void)?) {
        endBlock = block
    }

    public func textChange(_ block: ((_ textfield: MLTextField) -> Void)?) {
        addTarget(self, action: #selector(textValueChange(_:)), for: .editingChanged)
        changeBlock = block
    }

    @objc private func textValueChange(_ textfield: MLTextField) {
        changeBlock?(textfield)
    }

    /// 最大输入字数，-1 表示不限制
    public var maxCount: Int = -1

    /// 占位符颜色
    public var placeholderColor: UIColor? = .black {
        didSet { updatePlaceholder() }
    }

    /// 左侧内边距
    public var leftMargin: CGFloat = 10 {
        didSet { ml_leftView.frame.size.width = leftMargin }
    }

    private func updatePlaceholder() {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? " ",
            attributes: [.foregroundColor: placeholderColor ?? .black]
        )
    }

    private lazy var ml_leftView: UIView = {
        let view = UIView(frame: bounds)
        view.frame.size.width = leftMargin
        leftView = view
        leftViewMode = .always
        return view
    }()

    private var deleteKeyPressBlock: ((_ textfield: MLTextField) -> Void)?
    private var returnBlock: ((_ textfield: MLTextField) -> Void)?
    private var beginBlock: ((_ textfield: MLTextField) -> Void)?
    private var endBlock: ((_ textfield: MLTextField) -> Void)?
    private var changeBlock: ((_ textfield: MLTextField) -> Void)?
}

public extension MLTextField {
    convenience init(textColor: UIColor, placeholderColor: UIColor, palceholder str: String?, leftMargin: CGFloat = 15) {
        self.init(frame: .zero)
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.placeholder = str
        self.leftMargin = leftMargin
    }
}

extension MLTextField: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        returnBlock?(textField as! MLTextField)
        textField.resignFirstResponder()
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        beginBlock?(textField as! MLTextField)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        endBlock?(textField as! MLTextField)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard maxCount > 0 else { return true }
        let current = textField.text ?? ""
        guard let textRange = Range(range, in: current) else { return false }
        let updated = current.replacingCharacters(in: textRange, with: string)
        return updated.count <= maxCount
    }
}
