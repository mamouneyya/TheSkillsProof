//
//  Price.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/28/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit
import ObjectMapper

class Price: Root, Storable {
    
    // MARK: - Vars
    
    /// DB primary key. Without specifying it, SwiftyDB was unable to create the DB.
    var id = NSTimeIntervalSince1970 + Double(arc4random_uniform(999))
    
    var value = 0
    var currency = "$"
    
    var friendlyTitle: String {
        return "\(value) \(currency)"
    }
    
    var productId: String?
    var trackedDate = NSDate()
    
    // MARK: - Lifecycle
    
    override required init() {
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

extension Price: PrimaryKeys {
    /// Class object's primary key for SwiftyDB
    class func primaryKeys() -> Set<String> {
        return ["id"]
    }
}
