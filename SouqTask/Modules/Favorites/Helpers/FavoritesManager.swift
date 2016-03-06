//
//  FavoritesManager.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/5/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

class FavoritesManager {

    // MARK: - Public Vars
    
    /// Singleton's class shared instance
    static let sharedInstance = FavoritesManager()

    /// Type alias for actions that need to return single Product object.
    typealias ActionHandler = (object: Product?, error: ErrorType?) -> ()
    /// Type alias for actions that need to return array of Product objects.
    typealias ArrayActionHandler = (objects: [Product]?, error: ErrorType?) -> ()
    
    // MARK: - Private Vars
    
    /// SwiftyDB database object.
    private let database = SwiftyDB(databaseName: DBNames.Favorites)
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - CRUD Operations
    
    /**
        Get product synchronously from favorites DB by its Id.
        
        - Parameter productId: Product Id to fetch from the DB.
    
        - Returns: Product object if found, or nil.
    */
    class func getProductInFavorite(productId: String) -> Product? {
        let result = sharedInstance.database.objectsForType(Product.self, matchingFilter: ["id": productId])
        if let objects = result.value {
            return objects.first
        }
        return nil
    }
    
    /**
        Get product asynchronously from favorites DB by its Id.

        - Parameter productId:  Product Id to fetch from the DB.
        - Parameter action:     Action to fire when fetch completes.
     
        - NOTE: If you need to update views, make sure to run your code in the main thread (e.g. thorugh GCD)
    */
    class func asyncGetProductInFavorite(productId: String, action: ActionHandler) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let result = sharedInstance.database.objectsForType(Product.self, matchingFilter: ["id": productId])
            if let objects = result.value {
                action(object: objects.first, error: nil)
                return
            }
            action(object: nil, error: result.error)
        }
    }
    
    /**
        Get all favorited products asynchronously from DB.

        - Parameter action: Action to fire when fetch completes.
     
        - NOTE: If you need to update views, make sure to run your code in the main thread (e.g. thorugh GCD)
    */
    class func asyncGetAllProductsInFavorite(action: ArrayActionHandler) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let result = sharedInstance.database.objectsForType(Product.self)
            if let objects = result.value {
                action(objects: objects, error: nil)
                return
            }
            action(objects: nil, error: result.error)
        }
    }
    
    /**
        Update an existing product asynchronously in favorited DB. When passing the new product, the method will look for any existing product with the same Id, if found it'll use the info in the passed object to update it. Otherwise, it'll returns some error in the action closure.

        - Parameter product:  Product to update.
        - Parameter action:   Action to fire when fetch completes.
    */
    class func asyncUpdateProductInFavorite(product: Product, action: ActionHandler? = nil) {
        sharedInstance.database.asyncAddObject(product, update: true) { (result) -> Void in
            if let error = result.error {
                // TODO Handle error
                #if DEBUG
                    print(error)
                #endif
                action?(object: product, error: error)
            } else {
                action?(object: product, error: nil)
            }
        }
    }
    
    /**
        Add a product synchronously to the favorites DB.

        - Parameter product:    Product to add.

        - Returns: true if the inserting succeeded.
    */
    class func addProductToFavorite(product: Product) -> Bool {
        return sharedInstance.database.addObject(product, update: true).isSuccess
    }
    
    /**
        Add a product asynchronously to the favorites DB.

        - Parameter product:    Product to add.
        - Parameter action:     Action to fire when insertion completes.
    */
    class func asyncAddProductToFavorite(product: Product, action: ActionHandler? = nil) {
        sharedInstance.database.asyncAddObject(product, update: true) { (result) -> Void in
            if let error = result.error {
                // TODO Handle error
                #if DEBUG
                    print(error)
                #endif
                action?(object: product, error: error)
            } else {
                action?(object: product, error: nil)
            }
        }
    }

    /**
        Remove a product synchronously from the favorites DB, if exists.

        - Parameter product:    Product to remove.

        - Returns: true if the deletion succeeded.
    */
    class func removeProductFromFavorite(product: Product) -> Bool {
        return sharedInstance.database.deleteObjectsForType(Product.self, matchingFilter: ["id": product.id]).isSuccess
    }
    
    /**
        Remove a product asynchronously from the favorites DB.

        - Parameter product:    Product to remove.
        - Parameter action:     Action to fire when deletion completes.
    */
    class func asyncRemoveProductFromFavorite(product: Product, action: ActionHandler? = nil) {
        sharedInstance.database.asyncDeleteObjectsForType(Product.self, matchingFilter: ["id": product.id]) { (result) -> Void in
            if let error = result.error {
                // TODO Handle error
                #if DEBUG
                    print(error)
                #endif
                action?(object: product, error: error)
            } else {
                action?(object: product, error: nil)
            }
        }
    }
    
    // MARK: - Helpers
    
    /**
        Tells if a product exists in our favorites DB.

        - Parameter productId: Product id to look for.
    
        - Returns: true if the product found in favorites DB.
    */
    class func isProductFavorited(productId: String) -> Bool {
        if getProductInFavorite(productId) != nil {
            return true
        }
        
        return false
    }
    
}
