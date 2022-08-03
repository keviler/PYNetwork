//
//  YSBaseViewModel.swift
//  FKBase
//
//  Created by 周朋毅 on 2022/1/11.
//

import UIKit

open class YSBaseViewModel: NSObject {
    open lazy var network: PYNetwork = {
        let network = PYNetwork()
        return network
    }()
    
    deinit {
        self.network.session.cancelAllRequests()
    }
}
