//
//  BaseModel.swift
//  SwiftDemo
//
//  Created by 郭飞锋 on 2022/4/20.
//

import UIKit

struct BaseResponse<T: Codable>: Codable {
    var code: Int
    var data: T?
    var msg: String
}
