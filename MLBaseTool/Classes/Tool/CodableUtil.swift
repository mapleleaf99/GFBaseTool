//
//  CodableUtil.swift
//  MLBaseTool
//
//  Codable 模型与 JSON 字典/Data 之间的转换工具。
//

import Foundation

/// Codable 序列化工具
public class CodableUtil {

    /// 字典转 Model
    /// - Parameters:
    ///   - model: 目标模型类型
    ///   - dic: 字典数据
    /// - Returns: 解析成功返回模型，失败返回 nil 并输出日志
    public static func dicWithModel<T: Codable>(model: T.Type, dic: [String: Any]) -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dic)
            return try JSONDecoder().decode(model, from: data)
        } catch {
            MLLog("dicWithModel error: \(error)")
            return nil
        }
    }

    /// Data 转 Model
    public static func dataWithModel<T: Codable>(models: T.Type, data: Data) -> T? {
        do {
            return try JSONDecoder().decode(models, from: data)
        } catch {
            MLLog("dataWithModel error: \(error)")
            return nil
        }
    }

    /// Model 转字典
    public static func modelToDic<T: Codable>(_ model: T) -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(model)
            return try JSONSerialization.jsonObject(with: data) as? [String: Any]
        } catch {
            MLLog("modelToDic error: \(error)")
            return nil
        }
    }

    /// Model 转 JSON 字符串
    /// - Parameters:
    ///   - model: 模型实例
    ///   - prettyPrinted: 是否格式化输出
    public static func modelToJSONString<T: Codable>(_ model: T, prettyPrinted: Bool = false) -> String? {
        do {
            let encoder = JSONEncoder()
            if prettyPrinted {
                encoder.outputFormatting = .prettyPrinted
            }
            let data = try encoder.encode(model)
            return String(data: data, encoding: .utf8)
        } catch {
            MLLog("modelToJSONString error: \(error)")
            return nil
        }
    }
}
