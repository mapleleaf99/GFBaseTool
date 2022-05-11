//
//  CodableUtil.swift
//  SwiftDemo
//
//  Created by yun on 2021/8/12.
//

import Foundation

class CodableUtil {
    
    ///dic->model
    static func dicWithModel<T: Codable>(model: T.Type , dic: [String: Any]) -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted);
            return try JSONDecoder().decode(model, from: data)
        } catch  {
            return nil
        }
    }
    
    ///data->model
    static func dataWithModel <T: Codable> ( models : T.Type ,  data:Data) -> T? {
        do {
            return try JSONDecoder().decode(models, from: data)
        } catch  {
            return nil
        }
    }
    
}
 
