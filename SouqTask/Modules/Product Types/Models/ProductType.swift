//
//  ProductType.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/28/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit
import ObjectMapper

class ProductType: Root {
    
    // MARK: - Vars
    
    /// Product type Id.
    var id = ""
    /// Product type title.
    var title = ""
    
    /// Product type link.
    var url: NSURL?
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    // MARK: - Mappable
    
    override func mapping(map: Map) {
        id      <- map["id"]
        title   <- map["label_plural"]
        url     <- (map["link"], URLTransform())
    }
}