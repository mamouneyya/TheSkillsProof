//
//  Product.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/24/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit
import ObjectMapper

class Price {
    
    // MARK: Vars
    
    var value = 0
    var currency = "$"
    
    // MARK: Lifecycle
    
    init() {
        
    }
    
    init(_ value: Int) {
        self.value = value
    }
}

class Product: Mappable {

    // MARK: Vars
    
    var id = ""
    var categoryId = ""
    var title = ""
    
    var price = Price()
    var prices = [Price]()

    var imageURL: NSURL?
    
    var favorited = false

    // MARK: Lifecycle
    
    init() {

    }
    
    required init?(_ map: Map) {
        
    }
    
    // MARK: Mappable
    
    func mapping(map: Map) {
        id          <- map["id"]
        categoryId  <- map["product_type_id"]
        title       <- map["label"]
        price       <- map["offer_price"]
        imageURL    <- (map["images.L.0"], URLTransform())
    }
}
