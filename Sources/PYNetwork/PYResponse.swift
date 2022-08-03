//
//  PYResponse.swift
//  Teacher
//
//  Created by 周朋毅 on 2022/1/5.
//

import Foundation
 
public protocol Responsive {
    associatedtype Model: Decodable
    var data: Model? { get }
    var code: Int? { get }
    var msg: String? { get }
}

public struct PYResponse<Model>: Decodable where Model: Decodable {
    public var data: Model?
    public var code: Int?
    public var msg: String?
    
    init(data: Model?, code: Int? = nil, msg: String? = nil) {
        self.data = data
        self.code = code
        self.msg = msg
    }
}
