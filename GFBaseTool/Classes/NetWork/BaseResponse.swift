//
//  BaseResponse.swift
//  GFBaseTool
//
//  通用接口响应模型，需与后端 JSON 结构保持一致。
//

import Foundation

/// 通用 API 响应包装
/// 后端返回格式：{ "code": 0, "data": {...}, "msg": "success" }
public struct BaseResponse<T: Codable>: Codable {
    /// 业务状态码
    public var code: Int
    /// 业务数据
    public var data: T?
    /// 提示信息
    public var msg: String

    public init(code: Int, data: T?, msg: String) {
        self.code = code
        self.data = data
        self.msg = msg
    }
}
