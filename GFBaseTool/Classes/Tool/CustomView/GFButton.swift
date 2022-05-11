//
//  GFButton.swift
//  LvboLive
//
//  Created by 叫我锅先生 on 2018/1/29.
//  Copyright © 2018年 叫我锅先生. All rights reserved.
//

import UIKit
import AVFoundation

public enum GFButtonLayoutType: Int {
    case none = 0
    case rightText
    case leftText
    case topText
    case bottomText
}

public enum GFButtonAnimationType: Int {
    case none = 0
    case textScale
    case imageScale
    case transformScale
}

public class GFButton: UIButton {
    // MARK: 公开
    public typealias GFButtonBlock = (_ button: GFButton) -> Void
    /// 文字和图片的间距
    public var spacing: CGFloat = 0
    /// 最短长按时间
    public var minLongPressDuration: TimeInterval = 0.5
    /// 类型
    public var type: GFButtonLayoutType = .none
    
    public var animationType: GFButtonAnimationType = .none
    
//    /// disable background color
//    public var disableColor: UIColor?{
//        didSet{
//            if let color = disableColor {
//                let image = UIImage().GF.drawRect(CGSize(width: 2, height: 2), color: color).stretchableImage(withLeftCapWidth: 1, topCapHeight: 1)
//                setBackgroundImage(image, for: .disabled)
//            }
//        }
//    }
    
    public func buttonClick(_ block: @escaping GFButtonBlock){
        clickBlock = block
        listenTouchUpInside()
    }
    public func longPressBlock(_ block: @escaping GFButtonBlock){
        longPressBlock = block
        createLongPressGesture()
    }
    
    // MARK: 私有
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAnimation()
    }
    
    public convenience init (_ type: GFButtonLayoutType = .none){
        self.init(type: type, animationType: .none)
    }
    
    public convenience init (_ animationType: GFButtonAnimationType = .none){
        self.init(type: .none, animationType: animationType)
    }
    
    public convenience init(type: GFButtonLayoutType = .none, animationType: GFButtonAnimationType = .none){
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
        
        guard let title = self.titleLabel?.text as NSString?, let titleFont = self.titleLabel?.font else { return }
        
        let imageSize = self.imageRect(forContentRect: self.frame)
        
        let titleSize = title.size(withAttributes: [NSAttributedString.Key.font : titleFont])
        
        var titleInsets: UIEdgeInsets = self.titleEdgeInsets
        var imageInsets: UIEdgeInsets = self.imageEdgeInsets
        
        
        
        switch type {
        case .leftText:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                       right: -(titleSize.width * 2 + spacing))
        case .topText:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottomText:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        default:
            if width < imageSize.width + titleSize.width + spacing {
                self.frame.size.width = imageSize.width + titleSize.width + spacing * 2
            }
            titleInsets = UIEdgeInsets(top: 0, left: spacing*2, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0,
                                       right: 0)
            break
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
    
    private var longPressGesture: UILongPressGestureRecognizer?
    private var timer: DispatchSourceTimer?
    private var responseCount: Int = 0
    private var clickBlock: GFButtonBlock!
    private var longPressBlock: GFButtonBlock!
    private var tempImage: UIImage?
    private var tempFont: UIFont!
    private(set) var tempBackgroundColor: UIColor?
    
    
    private func setupAnimation(){
        addTarget(self, action: #selector(highlight(_:)), for: .touchDown)
        addTarget(self, action: #selector(stopAnimation), for: .touchCancel)
        addTarget(self, action: #selector(stopAnimation), for: .touchDragOutside)
        
    }
    
    private func createLongPressGesture(){
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureEvent(_:)))
        addGestureRecognizer(longPressGesture!)
    }
    
    private func clearTimer(){
        self.timer?.cancel()
        self.timer = nil
        
    }
    
    private func listenTouchUpInside(){
        addTarget(self, action: #selector(touchUpInsideEvent(_:)), for: .touchUpInside)
    }
    
    private func callback(){
        stopAnimation()
        if responseCount >= 1 {
            if let block = longPressBlock {
                /// 震动一下
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                block(self)
            }
        }else if responseCount == 0{
            if let block = clickBlock{
                block(self)
            }
        }
    }
}

extension UIImage {
    func imageSize(scale: CGFloat) -> UIImage? {
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

@objc extension GFButton {
    
    @objc private func highlight(_ button: GFButton){
        switch animationType {
        case .none: break
        case .textScale:
            guard let size = button.titleLabel?.font else { return }
            tempFont = size
            UIView.animate(withDuration: 0.25, animations: {
                button.titleLabel?.font = UIFont.systemFont(ofSize: size.pointSize * 1.2)
            }) { (_) in
                self.stopAnimation()
            }
        case .imageScale:
            tempImage = currentImage
            UIView.animate(withDuration: 0.25, animations: {
                button.setImage(button.currentImage?.imageSize(scale: 1.2), for: .normal)
            }) { (_) in
                self.stopAnimation()
            }
            
        case .transformScale:
            UIView.animate(withDuration: 0.25, animations: {
                button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { (_) in
                self.stopAnimation()
            }
        }
    }
    
    @objc private func stopAnimation(){
        switch animationType {
        case .none: break
        case .textScale:
            UIView.animate(withDuration: 0.25, animations: {
                self.titleLabel?.font = self.tempFont
            })
        case .imageScale:
            UIView.animate(withDuration: 0.25, animations: {
                self.setImage(self.tempImage, for: .normal)
            })
        case .transformScale:
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    @objc private func longPressGestureEvent(_ gesture: UILongPressGestureRecognizer){
        switch gesture.state {
        case .began:
            responseCount = 0
            clearTimer()
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
            timer?.schedule(deadline: .now(), repeating: minLongPressDuration)
            timer?.setEventHandler(handler: {[weak self] in
                DispatchQueue.main.async {
                    self?.responseCount += 1
                    self?.callback()
                    self?.clearTimer()
                }
            })
            timer?.resume()
            
        default:
            break
        }
    }
    
    @objc private func touchUpInsideEvent(_ button: GFButton){
        responseCount = 0
        callback()
    }
}
