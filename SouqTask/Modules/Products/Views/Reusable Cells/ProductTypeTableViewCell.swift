//
//  ProductTypeTableViewCell.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/4/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

class ProductTypeTableViewCell: BaseTableViewCell {
    
    // MARK: - Vars
    
    var productType = ProductType() {
        didSet {
            updateViews(productType: productType)
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(red:242/255.0, green:246/255.0, blue:249/255.0, alpha:1.0)
        
        self.tintColor = UIColor(red:44.0/255.0, green:62.0/255.0, blue:80.0/255.0, alpha:1.0)
        self.accessoryType = selected ? .Checkmark : .None
        self.selectedBackgroundView = selectedBackgroundView
        self.textLabel?.textColor = UIColor(red:44.0/255.0, green:62.0/255.0, blue:80.0/255.0, alpha:1.0)
        self.textLabel?.font = selected ? UIFont.boldSystemFontOfSize(16) : UIFont.systemFontOfSize(16)
    }
    
    // MARK: - Update Views
    
    private func updateViews(productType productType: ProductType) {
        self.textLabel?.text = productType.title
    }

}
