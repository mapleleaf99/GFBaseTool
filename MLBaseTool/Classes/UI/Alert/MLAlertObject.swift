//
//  MLAlertObject.swift
//  MLBaseTool
//
//  弹窗对象基类，配合 MLAlertManager 管理展示优先级与队列。
//

import UIKit

/// 弹窗对象协议
@objc public protocol MLAlertObjectDelegate {
    func showAlertObject()
    func showAlertObject(in view: UIView)
    func closeAlertObject()
}

/// 弹窗导航协议（push / pop 多级弹窗）
@objc public protocol MLAlertObjectNavigator {
    func pushAlertObject(_ object: MLAlertObject)
    func popAlertObject()
}

/// 弹窗优先级
@objc public enum MLAlertPriority: Int {
    case common = 0
    case low = 250
    case hight = 750
    case over = 850
    case max = 1000
}

/// 弹窗配置模型
@objc open class MLAlertModel: NSObject {
    @objc public var param: Any?
    @objc public var priority: MLAlertPriority = .common
    /// 是否自动管理弹窗内输入框与键盘（默认 true）
    @objc public var autoKeyboardManager: Bool = true
}

/// 弹窗对象基类，业务弹窗继承此类并实现 showAlertViewClass
@objc open class MLAlertObject: MLAlertModel, MLAlertObjectDelegate, MLAlertViewDelegate, MLAlertObjectNavigator {

    @objc public var alertView: MLAlertView?
    @objc public var previousView: UIView?

    @objc public var isClickEmptyForClose: Bool = false {
        didSet { alertView?.isClickEmptyForClose = isClickEmptyForClose }
    }

    @objc public var didAppearInWindow: (() -> Void)?
    @objc public var didDisappearFromWindow: (() -> Void)?

    @objc public init(param: Any? = nil) {
        super.init()
        self.param = param
        alertView = showAlertViewClass(param: param)
        alertView?.delegate = self
    }

    public override init() {
        super.init()
        alertView = showAlertViewClass(param: nil)
        alertView?.delegate = self
    }

    /// 子类重写，返回自定义弹窗视图
    @objc open func showAlertViewClass(param: Any?) -> MLAlertView? {
        let view = MLAlertView()
        view.updateParam(param)
        return view
    }

    @objc open func updateWhenShowAlertObject() {
        alertView?.updateWhenShowAlertObject()
    }

    // MARK: - Show

    @objc open func showAlertObject() {
        MLKeyboardManager.shared.enable = autoKeyboardManager
        MLAlertManager.shared.requestShowAlertObject(self, nil)
        updateWhenShowAlertObject()
    }

    @objc open func showAlertObject(in view: UIView) {
        MLKeyboardManager.shared.enable = autoKeyboardManager
        MLAlertManager.shared.requestShowAlertObject(self, view)
        updateWhenShowAlertObject()
    }

    // MARK: - Close

    @objc open func closeAlertObject() {
        MLKeyboardManager.shared.enable = false
        MLAlertManager.shared.requestCloseAlertObject(self)
    }

    public func closeAlertIfNeed() {
        MLKeyboardManager.shared.enable = false
        MLAlertManager.shared.requestCloseAlertObject(self)
    }

    public func closeAllAlertIfNeed() {
        MLAlertManager.shared.requestCloseAllAlertObject()
    }

    @objc open func pushAlertObject(_ object: MLAlertObject) {
        MLAlertManager.shared.requestPushAlertObject(from: self, to: object)
    }

    @objc open func popAlertObject() {
        MLAlertManager.shared.requestPopAlertObject()
    }
}
