//
//  StringExtension.swift
//  SmartZhome
//
//  Created by 叫我锅先生 on 2020/11/20.
//  Copyright © 2020 叫我锅先生. All rights reserved.
//

import Foundation
import UIKit

extension String {

    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    ///计算字符串的宽度
    func gf_widthForComment(font: UIFont?, height: CGFloat = 15) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        return rect.width
    }
    
    func gf_heightForComment(font: UIFont?, width: CGFloat = UIScreen.main.bounds.width) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        return rect.height
    }
    
    func gf_heightForComment(attributes: [NSAttributedString.Key: Any], width: CGFloat = UIScreen.main.bounds.width) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.height
    }
    
    ///根据类名创建类
    func getClassFromString() -> AnyClass? {
        guard let spaceName = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            debugPrint("获取命名空间失败")
            return nil
        }
        
        if self.contains(spaceName) {
            return NSClassFromString(self)
        } else {
            return NSClassFromString(spaceName + "." + self)
        }
    }
}
