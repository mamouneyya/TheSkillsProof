//
//  ProductCollectionViewCell.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/23/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var productTitle: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var deleteFavoriteButton: UIButton!
    
    // MARK: - Vars
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Actions
    
    @IBAction func favoriteButtonTapped(sender: AnyObject) {
    
    }
    
    @IBAction func deleteFavoriteButtonTapped(sender: AnyObject) {
    
    }
    
}
