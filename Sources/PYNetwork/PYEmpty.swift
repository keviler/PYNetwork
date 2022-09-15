//
//  PYEmpty.swift
//  YaShi
//
//  Created by 周朋毅 on 2022/8/12.
//  Copyright © 2022 youngCoding. All rights reserved.
//

import HandyJSON

struct PYEmpty: HandyJSON {
    
}

extension Array: _ExtendCustomModelType where Element: _ExtendCustomModelType {}
extension Array: HandyJSON where Element: HandyJSON {}
extension Dictionary: _ExtendCustomModelType where Value: Hashable {}
extension Dictionary: HandyJSON where Value: Hashable {}
