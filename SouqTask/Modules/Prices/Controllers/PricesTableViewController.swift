//
//  ProductTrackedPricesViewController.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/5/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

class PricesTableViewController: BaseTableViewController {

    // MARK: - Vars
    
    var productId: String?
    
    var prices = [Price]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
        //let p = Price(0)
        //p.currency = "$"
        //p.productId = self.productId
        //p.trackedDate = NSDate()
        //PricesManager.asyncAddPriceForProduct(p) { (object, error) -> () in
            //print(object)
            //print(error)
        //}
        
        //PricesManager.asyncRemoveAllPricesForProduct(self.productId!) { (object, error) -> () in
            //print(object)
            //print(error)
        //}
        
        if let productId = productId {
            getPrices(productId)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Initialize
    
    /**
        Configure table view before initially display.
    */
    private func initialize() {
        self.tableView.rowHeight = 55.0
        self.tableView.allowsSelection = false
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    // MARK: - Get Data
    
    /**
        Asynchronously get all previously tracked prices for a product from our DB.
        
        - Parameter productId: The product Id to fetch its stored prices.
    */
    func getPrices(productId: String) {
        PricesManager.asyncGetAllPricesForProduct(productId) { (objects, error) -> () in
            guard error == nil else { return }
            
            print(objects)
            print(error)
            
            if let objects = objects {
                self.prices = objects
            }
        }
    }

}

// MARK: - Table Data Source

extension PricesTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Identifiers.TableCells.Price, forIndexPath: indexPath) as! PriceTableViewCell
        
        // configure cell
        cell.price = self.prices[indexPath.row]
        
        return cell
    }
    
}