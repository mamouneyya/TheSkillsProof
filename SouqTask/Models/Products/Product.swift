//
//  Product.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/24/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

class Price {
    var value = 0
    var currency = "$"
    
    init(_ value: Int) {
        self.value = value
    }
}

class Product {

    var id = ""
    var title = ""
    
    var price = Price(0)
    var prices = [Price]()

    var imageURL: NSURL?
    
    var favorited = false
    
}
