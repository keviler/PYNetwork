//
//  PYBaseViewModel.swift
//  FKBase
//
//  Created by 周朋毅 on 2022/1/11.
//

import UIKit

open class PYBaseViewModel: NSObject {
    open lazy var network: PYNetwork = {
        let network = PYNetwork()
        return network
    }()
    
    deinit {
        self.network.session.cancelAllRequests()
    }
}
