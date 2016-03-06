//
//  PricesManager.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/5/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

class PricesManager {

    // MARK: - Public Vars
    
    /// Singleton's class shared instance
    static let sharedInstance = PricesManager()
    
    /// Type alias for actions that need to return single Price object.
    typealias ActionHandler = (object: Price?, error: ErrorType?) -> ()
    /// Type alias for actions that need to return array of Price objects.
    typealias ArrayActionHandler = (objects: [Price]?, error: ErrorType?) -> ()
    
    // MARK: - Private Vars
    
    /// SwiftyDB database object.
    private let database = SwiftyDB(databaseName: DBNames.TrackedPrices)
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - CRUD Operations
    
    /**
    Get all prices for product asynchronously from DB.
    
    - Parameter productId:  Product Id to get tracked prices for.
    - Parameter action:     Action to fire when fetch completes.
    
    - NOTE: If you need to update views, make sure to run your code in the main thread (e.g. thorugh GCD)
    */
    class func getAllPricesForProduct(productId: String) -> [Price]? {
        let result = sharedInstance.database.objectsForType(Price.self, matchingFilter: ["productId": productId])
        if let objects = result.value {
            return objects
        }
        return nil
    }
    
    /**
        Get all prices for product asynchronously from DB.

        - Parameter productId:  Product Id to get tracked prices for.
        - Parameter action:     Action to fire when fetch completes.

        - NOTE: If you need to update views, make sure to run your code in the main thread (e.g. thorugh GCD)
    */
    class func asyncGetAllPricesForProduct(productId: String, action: ArrayActionHandler) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let result = sharedInstance.database.objectsForType(Price.self, matchingFilter: ["productId": productId])
            if let objects = result.value {
                action(objects: objects, error: nil)
                return
            }
            action(objects: nil, error: result.error)
        }
    }

    /**
        Add a new price for product asynchronously.

        - Parameter price:  Price to add.
        - Parameter action: Action to fire when insertion completes.
    */
    class func asyncAddPriceForProduct(price: Price, action: ActionHandler? = nil) {
        sharedInstance.database.asyncAddObject(price, update: false) { (result) -> Void in
            if let error = result.error {
                // TODO Handle error
                #if DEBUG
                    print(error)
                #endif
                action?(object: nil, error: error)
            } else {
                action?(object: price, error: nil)
            }
        }
    }

    /**
        Remove all prices for specific product asynchronously. This can be used to clean DB when untrack a product.

        - Parameter product:    Product to remove.
        - Parameter action:     Action to fire when deletion completes.
    */
    class func asyncRemoveAllPricesForProduct(productId: String, action: ActionHandler? = nil) {
        sharedInstance.database.asyncDeleteObjectsForType(Price.self, matchingFilter: ["productId": productId]) { (result) -> Void in
            if let error = result.error {
                // TODO Handle error
                #if DEBUG
                    print(error)
                #endif
                action?(object: nil, error: error)
            } else {
                action?(object: nil, error: nil)
            }
        }
    }
    
    // MARK: - Helpers
    
    /**
        Look for the last tracked price in DB for a product.
        
        - Parameter productId: Product id to look for.

        - Returns: Last tracked price if exists, or nil.
    */
    class func lastTrackedPriceForProduct(productId: String) -> Int? {
        if let prices = getAllPricesForProduct(productId) where prices.count > 0 {
            return prices.last?.value
        }
        
        return nil
    }
    
}