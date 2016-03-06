//
//  BackgroundFetcher.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/6/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

class BackgroundFetcher {

    // MARK: - Public Vars
    
    /// Singleton's class shared instance
    static let sharedInstance = BackgroundFetcher()
    
    typealias FetchResultHandler = (UIBackgroundFetchResult) -> ()
    typealias FetchProductHandler = (success: Bool, updated: Bool) -> ()
    
    private init() {}
    
    func updateTrackedPricesForFavoritedProducts(completion: FetchResultHandler) {
        FavoritesManager.asyncGetAllProductsInFavorite { (products, error) -> () in
            if let products = products where products.count > 0 {
                var requestsCount = 0
                var succeededRequestsCount = 0
                var updatedAtLeastOne = false
                
                for product in products {
                    self.requestProductWithUpdatingPricesIfNeeded(product.id, completion: { (success, updated) -> () in
                        requestsCount++
                        
                        if success {
                            succeededRequestsCount++
                        }
                        
                        if updated {
                            updatedAtLeastOne = true
                        }
                        
                        if requestsCount == products.count {
                            // be forgiveness with up to two failed requests
                            if succeededRequestsCount >= products.count - 2 {
                                if updatedAtLeastOne {
                                    completion(UIBackgroundFetchResult.NewData)
                                } else {
                                    completion(UIBackgroundFetchResult.NoData)
                                }
                            } else {
                                completion(UIBackgroundFetchResult.Failed)
                            }
                        }
                        
                    })
                }

            } else if error != nil {
                completion(UIBackgroundFetchResult.Failed)
            } else {
                completion(UIBackgroundFetchResult.NoData)
            }
        }
    }
    
    private func requestProductWithUpdatingPricesIfNeeded(productId: String, completion: FetchProductHandler? = nil) {
        Networker.request(Product.Request.getProduct(productId: productId)).responseObject { (response: Response<Product, NSError>) -> Void in
            switch response.result {
            case .Success(let product):
                product.updateTrackedPrices() { (updated) -> () in
                    print("Item updated: \(updated)")
                    completion?(success: true, updated: updated)
                }
            case .Failure(_):
                print("Item update failed!: \(productId)")
                completion?(success: false, updated: false)
            }
        }
    }
}
