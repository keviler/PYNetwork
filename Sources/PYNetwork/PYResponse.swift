//
//  PYResponse.swift
//  Teacher
//
//  Created by 周朋毅 on 2022/1/5.
//

import Foundation
import HandyJSON

public struct PYResponse<Model>: HandyJSON where Model : HandyJSON {
    public init() {
        
    }
    
    public var data: Model?
    public var code: Int?
    public var msg: String?
    
    init(data: Model? = nil, code: Int? = nil, msg: String? = nil) {
        self.data = data
        self.code = code
        self.msg = msg
    }
}
