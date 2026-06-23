//
//  ToolManager.swift
//  GFBaseTool
//
//  通用业务工具：拨打电话、JSON 转换、敏感词过滤、正则校验。
//

import UIKit

/// 通用工具管理类
public class ToolManager: NSObject {

    // MARK: - 打电话

    /// 弹出确认框后拨打电话
    /// - Parameters:
    ///   - titleStr: 弹窗标题
    ///   - phoneNumStr: 电话号码，会自动去除空格
    ///   - viewCtrl: 用于 present 弹窗的控制器
    public static func callPhone(titleStr: String, phoneNumStr: String?, viewCtrl: UIViewController?) {
        guard let phoneNumStr = phoneNumStr?.replacingOccurrences(of: " ", with: ""),
              !phoneNumStr.isEmpty,
              let viewCtrl = viewCtrl,
              let url = URL(string: "tel://" + phoneNumStr) else {
            return
        }

        let alertController = UIAlertController(title: titleStr, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        alertController.addAction(UIAlertAction(title: "确定", style: .destructive) { _ in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        alertController.popoverPresentationController?.sourceView = viewCtrl.view
        alertController.popoverPresentationController?.sourceRect = CGRect(
            x: 0, y: ScreenHeight, width: ScreenWidth, height: ScreenHeight
        )
        viewCtrl.present(alertController, animated: true)
    }

    // MARK: - JSON

    /// JSON 字符串转字典
    public static func getDicFromJSONString(jsonString: String) -> [String: Any]? {
        guard let jsonData = jsonString.data(using: .utf8),
              let obj = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers),
              let dic = obj as? [String: Any] else {
            return nil
        }
        return dic
    }

    /// 字典转 JSON 字符串
    public static func getJSONStringFromDic(dic: [String: Any], prettyPrinted: Bool = false) -> String {
        let options: JSONSerialization.WritingOptions = prettyPrinted ? .prettyPrinted : []
        guard let data = try? JSONSerialization.data(withJSONObject: dic, options: options) else {
            return ""
        }
        return String(data: data, encoding: .utf8) ?? ""
    }

    // MARK: - 敏感词

    /// 检查文本是否通过敏感词校验
    /// - Returns: true 表示不含敏感词，false 表示包含敏感词
    @objc public static func checkSensitiveWords(wordStr: String) -> Bool {
        if wordStr.isEmpty || sensitiveWords.isEmpty { return true }
        for sensitiveStr in sensitiveWords where !sensitiveStr.isEmpty {
            if wordStr.contains(sensitiveStr) {
                return false
            }
        }
        return true
    }

    /// 若包含敏感词则替换为 **，否则返回原文
    @objc public static func checkSensitiveWordsReplacedWithAsterisk(wordStr: String) -> String {
        if wordStr.isEmpty || sensitiveWords.isEmpty { return wordStr }
        for sensitiveStr in sensitiveWords where !sensitiveStr.isEmpty {
            if wordStr.contains(sensitiveStr) {
                return "**"
            }
        }
        return wordStr
    }

    /// 重新加载敏感词库
    /// 优先读取宿主 App 的 main bundle，其次读取 Pod bundle
    /// 词库文件名为 sensitiveWord.txt，词语以英文逗号分隔
    public static func reloadSensitiveWords() {
        sensitiveWords = loadSensitiveWords()
    }

    /// 当前敏感词列表
    public static var sensitiveWords: [String] = loadSensitiveWords()

    private static func loadSensitiveWords() -> [String] {
        let paths = [
            Bundle.main.path(forResource: "sensitiveWord", ofType: "txt"),
            Bundle(for: ToolManager.self).path(forResource: "sensitiveWord", ofType: "txt")
        ]
        for path in paths.compactMap({ $0 }) {
            if let string = try? String(contentsOfFile: path, encoding: .utf8) {
                return string
                    .components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
            }
        }
        return []
    }

    // MARK: - 正则

    /// 正则校验
    public static func isValid(_ checkStr: String, regex: String) -> Bool {
        return checkStr.isValid(regex: regex)
    }
}
