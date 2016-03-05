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
    
    var product = Product() {
        didSet {
            updateViews(product: product)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TICK()
        
        for i in 0 ..< 55 {
            Networker.request(Product.Request.getProduct(productId: "7278383"))
                .responseObject(silent: true) { (response: Response<Product, NSError>) -> Void in
                    switch response.result {
                    case .Success(let data):
                        print(data.price)
                    case .Failure(_):
                        print("Failure")
                    }
                    
                    if i == 24 {
                        TOCK()
                    }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Update Views
    
    func updateViews(product product: Product) {

    }

}

// MARK: - Table Data Source

extension PricesTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.product.prices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Identifiers.TableCells.ProductType, forIndexPath: indexPath) as! ProductTypeTableViewCell
        
        // configure cell
        //cell.productType = self.productTypes[indexPath.row]
        
        return cell
    }
    
}