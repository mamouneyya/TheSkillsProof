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
    
    /// Product data model object, to fill subview data from.
    var product = Product() {
        didSet {
            //updateViews(product: product)
        }
    }
    
    /// Weak reference to the collection view's cell we came from. We use this to sync favorite statuses for this product when updating at this level.
    weak var sourceCell: ProductCollectionViewCell?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        
        // Due to what it seems a bug, calling this in product's propery didSet
        // won't work when initializing the controller from storyboard (it works
        // as expected when using segue though) as all outlets aren't initialized
        // at that stage (nils)
        updateViews(product: product)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        self.tableView.reloadData()
    }

    // MARK: - Initialize
    
    /**
        Configure views before initially displaying them.
    */
    private func initializeViews() {
        self.favoriteButton.setTitle("Add to Favorite", forState: .Normal)
        self.favoriteButton.setTitle("Remove from Favorite", forState: .Selected)

        self.favoriteButton.setTitleColor(Colors.mainTint, forState: .Normal)
        self.favoriteButton.setTitleColor(Colors.Destructive, forState: .Selected)
        
        self.favoriteButton.selected = self.product.favorited
    }
    
    // MARK: - Update Views
    
    /**
        Fills subviews from model data object.
        
        - Parameter product: Product data model to use.
    */
    private func updateViews(product product: Product) {
        self.productTitleLabel.text = product.title
        
        self.lastPriceLabel.text = product.price.friendlyTitle
        self.lastPriceDateLabel.text = "currently"
        
        if let imageURL = product.imageURL {
            self.productImageView.af_setImageWithURL(imageURL)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func favoriteButtonTapped(sender: UIButton) {
        func reloadState() {
            // toggle status
            sender.selected = !sender.selected
            
            self.tableView.beginUpdates()
            // show / hide prices tracking area
            if self.product.favorited {
                self.tableView.insertSections(NSIndexSet(index: 1), withRowAnimation: .Fade)
            } else {
                self.tableView.deleteSections(NSIndexSet(index: 1), withRowAnimation: .Fade)
            }
            self.tableView.endUpdates()
        }
        
        if sender.selected {
            Utility.showConfirmationAlert("Remove product from favorite?", target: self, action: { () -> () in
                FavoritesManager.asyncRemoveProductFromFavorite(self.product, action: { (object, error) -> () in
                    if error == nil {
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            reloadState()
                            // update list / favorites tables
                            self.sourceCell?.removeFromFavorite()
                        }
                    }
                })
            })
        } else {
            FavoritesManager.asyncAddProductToFavorite(self.product, action: { (object, error) -> () in
                if error == nil {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        reloadState()
                        // update list / favorites tables
                        self.sourceCell?.addToFavorite()
                    }
                }
            })
        }
        

    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    /**
        Navigate to product's all previously tracked prices table view controller.
    */
    private func goToAllPreviousPrices() {
        let pricesController = StoryboardScene.Main.instanciateProductPrices()
            pricesController.productId = self.product.id

        self.navigationController?.pushViewController(pricesController, animated: true)
    }

}

// MARK: - Table Data Source

extension ProductTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.product.favorited ? 2 : 1
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
