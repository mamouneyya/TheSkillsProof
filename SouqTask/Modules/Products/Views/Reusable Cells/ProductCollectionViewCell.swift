//
//  ProductCollectionViewCell.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/23/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

enum ProductCellConfigurationsSet {
    case All
    case Favorited
}

class ProductCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var borderMaskImageView: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Vars
    
    /// Product data model for the cell to fill its subviews.
    var product = Product() {
        didSet {
            updateViews(product: product)
        }
    }
    
    /// Configuration set for the cell, inherited from its collection view.
    var configurationsSet: ProductCellConfigurationsSet {
        return self.mainCollectionView?.configurationsSet.cellConfigurationsSet() ?? .All
    }
    
    /// Weak reference to the cell's products collection view.
    weak var mainCollectionView: ProductsCollectionView?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.borderMaskImageView.image = UIImage.ResizableAsset.RoundedShadowMask.image
    }

    // MARK: - Update Views
    
    /**
        Update cell's views from the model data object.
        
        - Parameter product: Product data model to use.
    */
    func updateViews(product product: Product) {
        self.productTitleLabel.text = product.title
        
        if self.configurationsSet == .All {
            self.favoriteButton.selected = self.product.favorited
        }
        
        // TODO use a nice placeholder
        self.productImageView.image = nil
        if let productImageURL = product.imageURL {
            self.productImageView.af_setImageWithURL(productImageURL)
        }
    }

    // MARK: - Helpers
    
    /**
        Add current product to favorites. This method syncs the favorite status of this product in other places in the app by posting some notifications to the product collection views.
    */
    func addToFavorite() {
        if self.configurationsSet == .All {
            self.favoriteButton.selected = true
            
            FavoritesManager.asyncAddProductToFavorite(self.product) { (_, error) -> () in
                // if error happens, toggle button state again
                // TODO needs better error handling
                if error != nil {
                    self.favoriteButton.selected = false
                }
            }
            
            self.mainCollectionView?.refreshProductsFavoriteStatus()
        }
    }
    
    /**
        Remove curent product from favorites, if exists. This method syncs the favorite status of this product in other places in the app by posting some notifications to the product collection views.
    */
    func removeFromFavorite() {
        if self.configurationsSet == .All {
            self.favoriteButton.selected = false
            
            FavoritesManager.asyncRemoveProductFromFavorite(self.product) { (_, error) -> () in
                // if error happens, toggle button state again
                // TODO needs better error handling
                if error != nil {
                    self.favoriteButton.selected = true
                }
            }
            
            self.mainCollectionView?.refreshProductsFavoriteStatus()

        } else if self.configurationsSet == .Favorited {
            self.mainCollectionView?.deleteFavoritedProductInCell(self)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func favoriteButtonTapped(sender: UIButton) {
        if self.configurationsSet == .All {
            if !sender.selected {
                addToFavorite()
            } else {
                removeFromFavorite()
            }
        } else {
            Utility.showConfirmationAlert("Remove product from favorite?") { () -> () in
                self.removeFromFavorite()
            }
        }
    }
    
}
