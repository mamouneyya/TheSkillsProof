//
//  Product.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/24/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit
import ObjectMapper

class Product: Root, Storable {

    // MARK: - Public Vars
    
    /// Product's ID.
    var id = ""
    /// ID of the product type it belongs.
    var categoryId = ""
    /// Product's title.
    var title = ""
    /// All previously tracked prices for the product.
    var prices = [Price]()

    /// Product's price.
    var price: Price {
        return Price(value: priceValue, currency: priceCurrency)
    }

    /// Product's image URL.
    var imageURL: NSURL? {
        if let imageLink = imageLink {
            return NSURL(string: imageLink)
        }
        
        return nil
    }
    
    /// Whether the product is favorited by user.
    var favorited: Bool {
        get {
            return FavoritesManager.isProductFavorited(self.id)
        }
        set {
            if newValue {
                FavoritesManager.addProductToFavorite(self)
            } else {
                FavoritesManager.removeProductFromFavorite(self)
            }
        }
    }

    // MARK: - Private Vars
    
    // NOTE I had to make them public. Otherwise SwiftyDB crashes while trying to grab / set them
    
    var priceValue: Int = 0
    var priceCurrency = ""
    var imageLink: String?
    
    // MARK: - Lifecycle
    
    override required init() {
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    // MARK: - Mappable
    
    override func mapping(map: Map) {
        id            <- map["id"]
        categoryId    <- map["product_type_id"]
        title         <- map["label"]

        priceValue    <- map["offer_price"]
        priceCurrency <- map["currency"]
        
        imageLink     <- map["images.L.0"]
    }
}

// MARK: - Storable

extension Product: PrimaryKeys {
    /// Class object's primary key for SwiftyDB
    class func primaryKeys() -> Set<String> {
        return ["id"]
    }
}
