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
    
    var price = Price() {
        didSet {
            updateViews(price: price)
        }
    }
    
    // MARK: - Update Views
    
    private func updateViews(price price: Price) {
        self.priceLabel.text = price.friendlyTitle
        self.priceLabel.text = price.trackedDate
    }

}
