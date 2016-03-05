//
//  ProductViewController.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/5/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

class ProductTableViewController: BaseTableViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!

    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var lastPriceDateLabel: UILabel!
    
    // MARK: - Public Vars
    
    var product = Product() {
        didSet {
            //updateViews(product: product)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Due to what it seems a bug, calling this in product's propery didSet
        // won't work when initializing the controller from storyboard (it works
        // as expected when using segue though) as all outlets aren't initialized
        // at that stage (nils)
        updateViews(product: product)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Update Views
    
    private func updateViews(product product: Product) {
        self.productTitleLabel.text = product.title
        
        self.lastPriceLabel.text = product.price.friendlyTitle
        self.lastPriceDateLabel.text = "N/A"
        
        if let imageURL = product.imageURL {
            self.productImageView.af_setImageWithURL(imageURL)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func favoriteButtonTapped(sender: AnyObject) {
        
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    private func goToAllPreviousPrices() {
        let pricesController = StoryboardScene.Main.instanciateProductPrices()
            pricesController.product = self.product
        self.navigationController?.pushViewController(pricesController, animated: true)
    }

}

// MARK: - Table Delegate

extension ProductTableViewController {

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableViewAutomaticDimension : 55.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableViewAutomaticDimension : 55.0
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row == 1 ? true : false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 1 {
            goToAllPreviousPrices()
        }
    }
    
}
