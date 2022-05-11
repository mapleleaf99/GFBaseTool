//
//  GFDottedLine.swift
//  Yoga
//
//  Created by 叫我锅先生 on 2019/5/8.
//  Copyright © 2019 叫我锅先生. All rights reserved.
//

import UIKit

//虚线
class GFDottedLine: UIView {

    //MARK: - System Method
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, strokeColor: UIColor) {
        self.init(frame: frame)
        
        self.strokeColor = strokeColor
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Property
    private var strokeColor: UIColor = kRGBColorFromHex(rgbValue: 0xeeeeee)
}

//MARK: - Private Method
extension GFDottedLine {
    private func setUp() {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.bounds = self.bounds
        
        shapeLayer.position = CGPoint(x: self.width / 2, y: self.height / 2)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 4), NSNumber(value: 2)]//线的宽度和间距
    
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 5))
        path.addLine(to: CGPoint(x: self.width, y: 5))
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
    }

}
