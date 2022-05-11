//
//  GFTextField.swift
//  LvboLive
//
//  Created by 叫我锅先生 on 2017/11/17.
//  Copyright © 2017年 叫我锅先生. All rights reserved.
//

import UIKit

public class GFTextField: UITextField {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        delegate = self
    }
    
    public override var placeholder: String? {
        didSet{
            self.attributedPlaceholder = NSAttributedString(string: placeholder ?? " ", attributes: [.foregroundColor:placeholderColor ?? .black])
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        self.setValue(self.placeholderColor, forKey: "placeholderColor")
        self.setValue(self.leftMargin, forKey: "leftMargin")
    }
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "placeholderColor"{
            self.placeholderColor = value as? UIColor
        }
        
        if key == "leftMargin" {
            self.leftMargin = value as! CGFloat
        }
    }
    
    public override func deleteBackward() {
        super.deleteBackward()
        deleteKeyPressBlock?(self)
    }
    
    public func deleteKeyPress(_ block : ((_ textfield : GFTextField)->Void)?) {
        deleteKeyPressBlock = block
    }
    
    public func pressReturn(_ block : ((_ textfield : GFTextField)->Void)?){
        returnBlock = block
    }
    public func beginEditing(_ block : ((_ textfield : GFTextField)->Void)?){
        beginBlock = block
    }
    public func endEditing(_ block : ((_ textfield : GFTextField)->Void)?){
        endBlock = block
    }
    public func textChange(_ block : ((_ textfield : GFTextField)->Void)?){
        addTarget(self, action: #selector(textValueChange(_:)), for: .editingChanged)
        changeBlock = block
    }
    
    @objc private func textValueChange(_ textfield : GFTextField) {
        changeBlock?(textfield)
    }
    
    // MARK: 属性
    public var maxCount: Int = -1
    public var placeholderColor: UIColor? = UIColor.black
    {
        didSet{
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? " ", attributes: [.foregroundColor:placeholderColor ?? .black])
        }
    }
    public var leftMargin : CGFloat = 10 {
        didSet{
            self.GF_leftView.frame.size.width = leftMargin
        }
    }
    
    private lazy var GF_leftView: UIView = {
         let view = UIView(frame: self.bounds)
        view.frame.size.width = self.leftMargin
        self.leftView = view
        self.leftViewMode = .always
        return view
    }()
    private lazy var deleteKeyPressBlock : ((_ textfield : GFTextField)->Void)? = nil
    private lazy var returnBlock : ((_ textfield : GFTextField)->Void)? = nil
    private lazy var beginBlock : ((_ textfield : GFTextField)->Void)? = nil
    private lazy var endBlock : ((_ textfield : GFTextField)->Void)? = nil
    private lazy var changeBlock : ((_ textfield : GFTextField)->Void)? = nil
}

public extension GFTextField {
    convenience init(textColor : UIColor, placeholderColor: UIColor, palceholder str: String?, leftMargin : CGFloat = 15) {
        self.init(frame: CGRect.zero)
        self.textColor = textColor
        self.placeholder = str
        self.setValue(placeholderColor, forKey: "placeholderColor")
        self.setValue(leftMargin, forKey: "leftMargin")
    }
}

extension GFTextField : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        returnBlock?(textField as! GFTextField)
        textField.resignFirstResponder()
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        beginBlock?(textField as! GFTextField)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        endBlock?(textField as! GFTextField)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if maxCount == -1 {
            return true
        }
        
        if range.location < maxCount {
            return true
        }
        
        return false
        
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
