//
//  MLAlertView.swift
//  MLBaseTool
//
//  弹窗视图基类，支持点击空白关闭、参数传递。
//

import UIKit

/// 弹窗视图代理
public protocol MLAlertViewDelegate: AnyObject {
    /// 关闭当前弹窗
    func closeAlertIfNeed()
    /// 关闭所有弹窗
    func closeAllAlertIfNeed()
}

/// 弹窗视图基类
open class MLAlertView: UIView {

    /// 初始化参数
    public var param: Any?
    /// 业务数据
    public var data: Any?
    /// 弹窗管理代理
    public weak var delegate: MLAlertViewDelegate?

    /// 点击空白处是否关闭，为 true 时需实现 setContentView()
    public var isClickEmptyForClose: Bool = false {
        didSet {
            guard isClickEmptyForClose else { return }
            let tap = UITapGestureRecognizer(target: self, action: #selector(clickEmptyAction(_:)))
            tap.delegate = self
            addGestureRecognizer(tap)
        }
    }

    /// 指定内容区域，用于判断点击空白关闭
    open func setContentView() -> UIView? {
        return nil
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    open func updateParam(_ param: Any?) {
        self.param = param
    }

    open func updateData(_ data: Any?) {
        self.data = data
    }

    /// 子类重写初始化 UI
    open func setupView() {}

    /// 弹窗即将展示时刷新
    open func updateWhenShowAlertObject() {}

    @objc private func clickEmptyAction(_ gesture: UITapGestureRecognizer) {
        guard let contentView = setContentView() else { return }
        let location = gesture.location(in: self)
        if !contentView.frame.contains(location) {
            delegate?.closeAlertIfNeed()
        }
    }

    @objc open func didSelectedClose() {
        delegate?.closeAlertIfNeed()
    }
}

extension MLAlertView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let contentView = setContentView() else { return true }
        return touch.view?.isDescendant(of: contentView) != true
    }
}
