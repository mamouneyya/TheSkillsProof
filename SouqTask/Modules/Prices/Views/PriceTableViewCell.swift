//
//  PriceTableViewCell.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/5/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

class PriceTableViewCell: BaseTableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Vars
    
    /// Model data object, to fill cell subviews from.
    var price = Price() {
        didSet {
            updateViews(price: price)
        }
    }
    
    // MARK: - Update Views
    
    /**
        Fills cell's subviews using price model.
        
        - Parameter price: The price data model to use.
    */
    private func updateViews(price price: Price) {
        self.priceLabel.text = price.friendlyTitle
        self.dateLabel.text = price.trackedDate.userFriendlyDateString()
    }

}
