//
//  ProductsCollectionViewController.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/21/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

class ProductsCollectionViewController: BaseCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        (self.collectionView as? ProductsCollectionView)?.getProducts(configurationsSet: .All, target: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
