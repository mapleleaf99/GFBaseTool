//
//  NetWork.swift
//  GFBaseTool
//
//  基于 Alamofire 的网络请求封装，自动解析 BaseResponse 并回调 Model。
//

import Foundation
import Alamofire

/// 网络请求管理类（单例）
public class NetWork: NSObject {

    /// 单例
    public static let share = NetWork()

    /// 全局网络配置
    public var configuration: GFNetworkConfiguration {
        get { GFNetworkConfiguration.shared }
        set { GFNetworkConfiguration.shared = newValue }
    }

    private func baseRequestWithModel<T: Codable>(
        url: String,
        method: HTTPMethod,
        parameters: [String: Any]?,
        encoding: ParameterEncoding,
        token: String?,
        type: T.Type,
        showLoading: Bool?,
        success: ((T) -> Void)?,
        failure: ((Error) -> Void)?
    ) {
        let config = configuration
        let urlStr = config.baseURL + url
        let shouldShowLoading = showLoading ?? config.showLoading

        var extraHeaders: HTTPHeaders = [:]
        if let token = token {
            extraHeaders["token"] = token
        }
        let allHeaders = HTTPHeaders(
            config.defaultHeaders.merging(extraHeaders.dictionary) { $1 }
        )

        if shouldShowLoading {
            Toast.showProgress()
        }

        AF.request(
            urlStr,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: allHeaders
        ) { urlRequest in
            urlRequest.timeoutInterval = config.requestTimeout
        }
        .responseDecodable(of: BaseResponse<T>.self) { response in
            if shouldShowLoading {
                Toast.hiddenProgress()
            }

            DispatchQueue.main.async {
                switch response.result {
                case .success(let value):
                    if value.code == config.successCode {
                        if let data = value.data {
                            success?(data)
                        } else {
                            let error = GFNetworkError.emptyData
                            Toast.show(error.errorDescription)
                            failure?(error)
                        }
                    } else {
                        let error = GFNetworkError.business(code: value.code, message: value.msg)
                        Toast.show(value.msg)
                        failure?(error)
                    }
                case .failure(let error):
                    Toast.show(error.errorDescription)
                    failure?(error)
                }
            }
        }
    }
}

// MARK: - 公开接口

public extension NetWork {

    /// POST 请求，参数以 JSON Body 发送
    /// - Parameters:
    ///   - path: 接口路径（拼接到 baseURL 后）
    ///   - type: data 字段对应的 Model 类型
    ///   - param: 请求参数
    ///   - token: 可选 token，会写入请求头
    ///   - showLoading: 是否显示 Loading，nil 时使用全局配置
    func postUrlWithModel<T: Codable>(
        path: String,
        type: T.Type,
        param: [String: Any]? = nil,
        token: String? = nil,
        showLoading: Bool? = nil,
        success: ((T) -> Void)?,
        failure: ((Error) -> Void)? = nil
    ) {
        baseRequestWithModel(
            url: path,
            method: .post,
            parameters: param,
            encoding: JSONEncoding.default,
            token: token,
            type: type,
            showLoading: showLoading,
            success: success,
            failure: failure
        )
    }

    /// GET 请求，参数以 URL Query 发送
    func getUrlWithModel<T: Codable>(
        path: String,
        type: T.Type,
        param: [String: Any]? = nil,
        token: String? = nil,
        showLoading: Bool? = nil,
        success: ((T) -> Void)?,
        failure: ((Error) -> Void)? = nil
    ) {
        baseRequestWithModel(
            url: path,
            method: .get,
            parameters: param,
            encoding: URLEncoding.default,
            token: token,
            type: type,
            showLoading: showLoading,
            success: success,
            failure: failure
        )
    }
}
