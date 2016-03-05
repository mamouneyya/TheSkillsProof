//
//  Price.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/28/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit
import ObjectMapper

class Price: Root {
    
    // MARK: - Vars
    
    var value = 0
    var currency = "$"
    
    var friendlyTitle: String {
        return "\(value) \(currency)"
    }
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
    }
    
    init(value: Int, currency: String) {
        super.init()
        self.value = value
        self.currency = currency
    }
    
    init(_ value: Int) {
        super.init()
        self.value = value
    }

    required init?(_ map: Map) {
        super.init(map)
    }
    
}
