//
//  NetworkConfiguration.swift
//  MLBaseTool
//
//  网络层全局配置与统一错误类型定义。
//

import Foundation

/// 网络请求全局配置，通过 MLNetworkConfiguration.shared 修改
public struct MLNetworkConfiguration {

    /// 接口基础域名，如 https://api.example.com
    public var baseURL: String

    /// 业务成功状态码，与后端约定一致，默认 0
    public var successCode: Int

    /// 默认请求头
    public var defaultHeaders: [String: String]

    /// 是否自动显示 Loading Toast
    public var showLoading: Bool

    /// 请求超时时间（秒）
    public var requestTimeout: TimeInterval

    public init(
        baseURL: String = "",
        successCode: Int = 0,
        defaultHeaders: [String: String] = ["device-type": "ios", "device-info": ""],
        showLoading: Bool = true,
        requestTimeout: TimeInterval = 30
    ) {
        self.baseURL = baseURL
        self.successCode = successCode
        self.defaultHeaders = defaultHeaders
        self.showLoading = showLoading
        self.requestTimeout = requestTimeout
    }

    /// 全局共享配置实例
    public static var shared = MLNetworkConfiguration()
}

/// 网络层统一错误类型
public enum MLNetworkError: LocalizedError {
    /// 业务错误（code 非成功码）
    case business(code: Int, message: String)
    /// 成功但 data 为空
    case emptyData
    /// JSON 解析失败
    case decodeFailed

    public var errorDescription: String? {
        switch self {
        case .business(_, let message):
            return message
        case .emptyData:
            return "返回数据为空"
        case .decodeFailed:
            return "数据解析失败"
        }
    }
}
