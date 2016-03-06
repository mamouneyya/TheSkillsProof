//
//  FavoritesTableViewController.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/21/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

class FavoritesCollectionViewController: BaseCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // load data using .Favorited configurations set
        (self.collectionView as? ProductsCollectionView)?.loadData(configurationsSet: .Favorited, target: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Fight for your performance, buddy..
        self.collectionView?.reloadData()
    }

}
