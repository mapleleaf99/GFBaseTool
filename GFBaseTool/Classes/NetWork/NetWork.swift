//
//  NetWork.swift
//  SwiftDemo
//
//  Created by 叫我锅先生 on 2021/8/3.
//  Copyright © 2021 叫我锅先生. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class NetWork: NSObject {
    
    public static let share  = NetWork()
    
    ///isDataList: data返回值是数组
    private func baseRequestWithModel<T: Codable>(url: String, method: HTTPMethod, parameters: [String: Any]?, token: String?, type: T.Type, success:((T) -> Void)?, failure: ((Error?) -> Void)?) {
        let urlStr = NetWork.baseUrl + url
        
        var headers: HTTPHeaders?
        
        if let token = token {
            headers = ["token": token]
        }

        let allHeaders = HTTPHeaders(defaultHeaders.dictionary.merging((headers ?? []).dictionary) { $1 })
        
        Toast.showProgress()
        
        var response: DataResponse<BaseResponse<T>, AFError>?
        AF.request(urlStr, method: method, parameters: parameters, encoding: URLEncoding.default, headers: allHeaders)
            .responseDecodable(of: BaseResponse<T>.self) { (closureResponse) in
                response = closureResponse
//                debugPrint("返回值:", response?.result ?? "空的")
                
                Toast.hiddenProgress()

                switch response?.result {
                case .success(let value):
                    //可添加统一解析
                    DispatchQueue.main.async {
                        if value.code == 0 {
                            if let data = value.data {
                                debugPrint(data)
                                success?(data)
                                return
                            }
                        }
                        debugPrint("msg: \(value.msg)")
                        Toast.show(value.msg)
                    }
                    break
                case .failure(let error):
                    DispatchQueue.main.async {
                        failure?(error)
                        debugPrint("error: \(error.errorDescription ?? "空的")")
                        Toast.show(error.errorDescription)
                    }
                    break
                case .none:
                    break
                }
            }
    }
    
    private static let baseUrl: String = "http://43.128.102.151:10000"

    private var defaultHeaders: HTTPHeaders {
        let headers: HTTPHeaders = ["device-type": "ios", "device-info": ""]
        return headers
    }
    
}

//MARK: - public
extension NetWork {
    func postUrlWithModel<T: Codable>(path: String, type: T.Type, param: [String: Any]? = nil, token: String? = nil, success: ((T) -> Void)?, failure: ((Error?) -> Void)? = nil) {
        baseRequestWithModel(url: path, method: .post, parameters: param, token: token, type: type, success: success, failure: failure)
    }

    func getUrlWithModel<T: Codable>(path: String, type: T.Type, param: [String: Any]? = nil, token: String? = nil, success: ((T) -> Void)?, failure: ((Error?) -> Void)? = nil) {
        baseRequestWithModel(url: path, method: .get, parameters: param, token: token, type: type, success: success, failure: failure)
    }
}
