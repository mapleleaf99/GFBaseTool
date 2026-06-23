//
//  GFButton.swift
//  GFBaseTool
//
//  自定义按钮：支持图文布局、点击/长按回调、按下缩放动画。
//

import UIKit
import AVFoundation

/// 图文排列方式
public enum GFButtonLayoutType: Int {
    case none = 0       /// 默认：图左文右
    case rightText      /// 图左文右（带间距）
    case leftText       /// 图右文左
    case topText        /// 图上文下
    case bottomText     /// 图下文上
}

/// 按下时的动画效果
public enum GFButtonAnimationType: Int {
    case none = 0
    case textScale      /// 文字放大
    case imageScale     /// 图片放大
    case transformScale /// 整体缩放
}

/// 增强型 UIButton
public class GFButton: UIButton {

    public typealias GFButtonBlock = (_ button: GFButton) -> Void

    /// 图片与文字间距
    public var spacing: CGFloat = 0
    /// 长按触发间隔（秒），到达后震动并回调
    public var minLongPressDuration: TimeInterval = 0.5
    /// 图文布局类型
    public var type: GFButtonLayoutType = .none
    /// 按下动画类型
    public var animationType: GFButtonAnimationType = .none

    /// 设置点击回调
    public func buttonClick(_ block: @escaping GFButtonBlock) {
        clickBlock = block
        listenTouchUpInside()
    }

    /// 设置长按回调（触发时震动）
    public func onLongPress(_ block: @escaping GFButtonBlock) {
        longPressHandler = block
        createLongPressGesture()
    }

    /// 兼容旧命名
    @available(*, deprecated, renamed: "onLongPress(_:)")
    public func longPressBlock(_ block: @escaping GFButtonBlock) {
        onLongPress(block)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupAnimation()
    }

    public convenience init(_ type: GFButtonLayoutType = .none) {
        self.init(type: type, animationType: .none)
    }

    public convenience init(_ animationType: GFButtonAnimationType = .none) {
        self.init(type: .none, animationType: animationType)
    }

    public convenience init(type: GFButtonLayoutType = .none, animationType: GFButtonAnimationType = .none) {
        self.init(frame: .zero)
        self.type = type
        self.animationType = animationType
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAnimation()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        guard let title = titleLabel?.text as NSString?, let titleFont = titleLabel?.font else { return }

        let imageSize = imageRect(forContentRect: frame)
        let titleSize = title.size(withAttributes: [.font: titleFont])
        var titleInsets = titleEdgeInsets
        var imageInsets = imageEdgeInsets

        switch type {
        case .leftText:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
        case .topText:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottomText:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        default:
            if width < imageSize.width + titleSize.width + spacing {
                frame.size.width = imageSize.width + titleSize.width + spacing * 2
            }
            titleInsets = UIEdgeInsets(top: 0, left: spacing * 2, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: 0)
        }

        titleEdgeInsets = titleInsets
        imageEdgeInsets = imageInsets
    }

    private var longPressGesture: UILongPressGestureRecognizer?
    private var timer: DispatchSourceTimer?
    private var responseCount = 0
    private var clickBlock: GFButtonBlock?
    private var longPressHandler: GFButtonBlock?
    private var tempImage: UIImage?
    private var tempFont: UIFont!
    private(set) var tempBackgroundColor: UIColor?

    private func setupAnimation() {
        addTarget(self, action: #selector(highlight(_:)), for: .touchDown)
        addTarget(self, action: #selector(stopAnimation), for: .touchCancel)
        addTarget(self, action: #selector(stopAnimation), for: .touchDragOutside)
    }

    private func createLongPressGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureEvent(_:)))
        longPressGesture = gesture
        addGestureRecognizer(gesture)
    }

    private func clearTimer() {
        timer?.cancel()
        timer = nil
    }

    private func listenTouchUpInside() {
        addTarget(self, action: #selector(touchUpInsideEvent(_:)), for: .touchUpInside)
    }

    private func callback() {
        stopAnimation()
        if responseCount >= 1 {
            if let block = longPressHandler {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                block(self)
            }
        } else if responseCount == 0 {
            clickBlock?(self)
        }
    }
}

@objc extension GFButton {

    @objc private func highlight(_ button: GFButton) {
        switch animationType {
        case .none:
            break
        case .textScale:
            guard let size = button.titleLabel?.font else { return }
            tempFont = size
            UIView.animate(withDuration: 0.25, animations: {
                button.titleLabel?.font = UIFont.systemFont(ofSize: size.pointSize * 1.2)
            }) { _ in
                self.stopAnimation()
            }
        case .imageScale:
            tempImage = currentImage
            UIView.animate(withDuration: 0.25, animations: {
                button.setImage(button.currentImage?.imageSize(scale: 1.2), for: .normal)
            }) { _ in
                self.stopAnimation()
            }
        case .transformScale:
            UIView.animate(withDuration: 0.25, animations: {
                button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                self.stopAnimation()
            }
        }
    }

    @objc private func stopAnimation() {
        switch animationType {
        case .none:
            break
        case .textScale:
            UIView.animate(withDuration: 0.25) {
                self.titleLabel?.font = self.tempFont
            }
        case .imageScale:
            UIView.animate(withDuration: 0.25) {
                self.setImage(self.tempImage, for: .normal)
            }
        case .transformScale:
            UIView.animate(withDuration: 0.25) {
                self.transform = .identity
            }
        }
    }

    @objc private func longPressGestureEvent(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        responseCount = 0
        clearTimer()
        let timer = DispatchSource.makeTimerSource(flags: [], queue: .global())
        self.timer = timer
        timer.schedule(deadline: .now(), repeating: minLongPressDuration)
        timer.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                self?.responseCount += 1
                self?.callback()
                self?.clearTimer()
            }
        }
        timer.resume()
    }

    @objc private func touchUpInsideEvent(_ button: GFButton) {
        responseCount = 0
        callback()
    }
}
