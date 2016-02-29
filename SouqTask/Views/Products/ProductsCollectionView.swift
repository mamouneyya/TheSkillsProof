//
//  ProductsCollectionView.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/23/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

/**
    Products view configurations set (e.g. API calls, layout setup, etc.).

    - All: For all products list collection view.
    - Favorited: For favorited products collection view.
*/

enum ProductsListConfigurationsSet {
    case All
    case Favorited
    
    /**
        The equivalent cell configurations set for a specific view configurations.

        - Returns: The equivalent cell configurations set type.
    */
    func cellLayout() -> ProductCellConfigurationsSet {
        switch self {
        case .All:
            return ProductCellConfigurationsSet.All
        case .Favorited:
            return ProductCellConfigurationsSet.Favorited
        }
    }
}

class ProductsCollectionView: UICollectionView {

    // MARK: - Public Vars
    
    var products = [Product]()
    
    // MARK: - Private Vars
    
    private var configurationsSet = ProductsListConfigurationsSet.All {
        didSet {
            updateConfigurationsSet(configurationsSet)
        }
    }
    
    private var productCellIdentifier: String {
        return configurationsSet == .All ? Identifiers.productCell : Identifiers.favoritedCell
    }
    
    // MARK: - Public Methods
    
    func configureWithConfigurations(configurations: ProductsListConfigurationsSet) {
        self.configurationsSet = configurations
    }
    
    // MARK: - Private Methods
    
    /**
        Update the view configurations, including layout, data sources, etc.
        
        - Parameter configurations: Configurations set to use.
    */
    
    private func updateConfigurationsSet(configurations: ProductsListConfigurationsSet) {
        switch configurations {
        case .All:
            ()
        case .Favorited:
            ()
        }
    }
    
}

// MARK: - Collection View Data Source

extension ProductsCollectionView: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(productCellIdentifier, forIndexPath: indexPath) as! ProductCollectionViewCell
        
        cell.product = self.products[indexPath.row]
        
        return cell
    }
    
}

// MARK: - Collection View Delegate

extension ProductsCollectionView: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}