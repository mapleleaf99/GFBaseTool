//
//  ToolManager.swift
//  LvboLive
//
//  Created by 叫我锅先生 on 2021/4/18.
//  Copyright © 2021 叫我锅先生. All rights reserved.
//

import UIKit

class ToolManager: NSObject {

    //MARK:打电话
    ///打电话
    static func callPhone(titleStr: String, phoneNumStr: String?, viewCtrl: UIViewController?) {
        if phoneNumStr == nil || phoneNumStr?.count == 0 || viewCtrl == nil {
            return
        }
        
        let alertController: UIAlertController = UIAlertController(title: titleStr, message: nil, preferredStyle: UIAlertController.Style.alert)
        let cancel: UIAlertAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { (_) in
        })
        let confirm: UIAlertAction = UIAlertAction(title: "确定" , style: .destructive, handler: { (_) in
            let phoneStr =  phoneNumStr?.replacingOccurrences(of: " ", with: "")
            UIApplication.shared.openURL(NSURL(string : "tel://" + phoneStr!)! as URL)
        })
        alertController.addAction(cancel)
        alertController.addAction(confirm)
        alertController.popoverPresentationController?.sourceView = viewCtrl?.view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: ScreenHeight)
        viewCtrl?.present(alertController, animated: true, completion: nil)
    }
    
    ///json字符串转字典
    static func getDicFromJSONString(jsonString: String) -> [String: Any]? {
        if let jsonData = jsonString.data(using: .utf8),
            let obj = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers),
            let dic = obj as? [String: Any]{
            return dic
        }
        
        return nil
    }
    
    ///字典转json字符串
    static func getJSONStringFromDic(dic: [String: Any]) -> String {
        if let data = try? JSONSerialization.data(withJSONObject: dic, options: []) {
            let jsonString = String(data: data, encoding: .utf8)
            return jsonString ?? ""
        }
        return ""
    }

    //MARK:判断敏感字
    ///加@objc是为了在oc上可以调用该方法-用于私信的敏感词判断
    @objc static func checkSensitiveWords(wordStr: String) -> Bool {
     
        if wordStr.count == 0 {
            return true
        }

        if sensitiveWords.isEmpty {
            return true
        }
        
        for sensitiveStr in sensitiveWords
        {
            if wordStr.components(separatedBy: sensitiveStr).count > 1 {
                //弹窗
//                MBProgressHUD.showError("内容不得包含敏感字：" + sensitiveStr, to: nil)
                return false
            }
        }
        
        return true
    }
    
    ///检查敏感词替换成*
    @objc static func checkSensitiveWordsReplacedWithAsterisk(wordStr: String) -> String {
     
        if wordStr.count == 0 {
            return wordStr
        }

        if sensitiveWords.isEmpty {
            return wordStr
        }
        
        for sensitiveStr in sensitiveWords
        {
            if wordStr.components(separatedBy: sensitiveStr).count > 1 {
//                var asteriskStr: String = ""
//                for i in 0..<sensitiveStr.count {
//                    asteriskStr.append("*")
//                }
                return "**"
            }
        }
        
        return wordStr
    }

    ///获取敏感词库
    static var sensitiveWords: [String] = {
        var sensitiveWords: [String] = []
        if let path = Bundle.main.path(forResource: "sensitiveWord.txt", ofType: nil),
            let string = try? String(contentsOfFile: path, encoding: .utf8) {
            let list = string.components(separatedBy: ",")
            
            sensitiveWords = list
            sensitiveWords.removeLast()
        }
        
        return sensitiveWords
    }()
    
    ///正则判断
    static func isValid(_ checkStr: String, regex: String) -> Bool{
        let predicte = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicte.evaluate(with: checkStr)
    }
}
