//
//  Product.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/24/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit
import ObjectMapper

class Product: Root {

    // MARK: - Vars
    
    var id = ""
    var categoryId = ""
    var title = ""
    
    var price = Price()
    var prices = [Price]()

    var imageURL: NSURL?
    
    var favorited = false

    // MARK: - Lifecycle
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    // MARK: - Mappable
    
    override func mapping(map: Map) {
        id          <- map["id"]
        categoryId  <- map["product_type_id"]
        title       <- map["label"]
        price       <- map["offer_price"]
        imageURL    <- (map["images.L.0"], URLTransform())
    }
}
