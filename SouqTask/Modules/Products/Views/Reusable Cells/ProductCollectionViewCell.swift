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
    @IBOutlet weak var deleteFavoriteButton: UIButton!
    
    // MARK: - Vars
    
    var product = Product() {
        didSet {
            updateViews(product: product)
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.borderMaskImageView.image = UIImage.ResizableAsset.RoundedShadowMask.image
    }

    // MARK: - Update Views
    
    func updateViews(product product: Product) {
        self.productTitleLabel.text = product.title
        
        if let productImageURL = product.imageURL {
            self.productImageView.af_setImageWithURL(productImageURL)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func favoriteButtonTapped(sender: UIButton) {
        // TODO
        sender.selected = !sender.selected
        print("favoriteButtonTapped:")
    }
    
    @IBAction func deleteFavoriteButtonTapped(sender: UIButton) {
        // TODO
        print("deleteFavoriteButtonTapped:")
    }
    
}
