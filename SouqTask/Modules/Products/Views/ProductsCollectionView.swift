//
//  ProductsCollectionView.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/23/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

/**
    Products view configurations set (e.g. API calls, layout setup, etc.).

    - All: For all products list collection view.
    - Favorited: For favorited products collection view.
*/
enum ProductsListConfigurationsSet {
    case All
    case Favorited
    
    /**
        The equivalent cell configurations set for a specific view configurations.

        - Returns: The equivalent cell configurations set type.
    */
    func cellLayout() -> ProductCellConfigurationsSet {
        switch self {
        case .All:
            return ProductCellConfigurationsSet.All
        case .Favorited:
            return ProductCellConfigurationsSet.Favorited
        }
    }
}

class ProductsCollectionView: UICollectionView {

    // MARK: - Private Vars
    
    /////////////
    // DATA STUFF
    /////////////
    
    /// Configurations set of the data / appearance
    private var configurationsSet = ProductsListConfigurationsSet.All {
        didSet {
            updateConfigurationsSet(configurationsSet)
        }
    }
    
    /// Data models for the table view data source to use
    private var products = [Product]()
    
    /// Table's cells identifier for the table view data source to use
    private var productCellIdentifier = ""
    
    /// Main view controller, to use in case of navigation action
    private var mainController: UIViewController?
    
    // MARK: - Lifecycle
    
    deinit {
        removeObservers()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        registerCellNibs()
        
        initializeLayout()
        initializeCollectionView()
        
        addObservers()
    }
    
    // MARK: - Initializing
    
    /**
        Register reusable collection view's cells nib files, so they can be dequeued.
    */
    func registerCellNibs() {
        self.registerNib(UINib(nibName: "FeedProductCell", bundle: nil), forCellWithReuseIdentifier: Identifiers.CollectionCells.Product)
        self.registerNib(UINib(nibName: "FavoritedProductCell", bundle: nil), forCellWithReuseIdentifier: Identifiers.CollectionCells.Favorited)
    }
    
    /**
        Configure collection view flow layout's properties (e.g. item spacing, etc.).
    */
    func initializeLayout() {
        if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            let spacing: CGFloat = 10.0
            flowLayout.minimumLineSpacing = spacing
            flowLayout.minimumInteritemSpacing = spacing
            flowLayout.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing)
        }
    }
    
    /**
        Configure collection view, setting its data source, etc.
    */
    func initializeCollectionView() {
        self.dataSource = self
        self.delegate   = self
    }
    
    // MARK: - Public Methods
    
    func getProducts(configurationsSet configurationsSet: ProductsListConfigurationsSet, target: AnyObject? = nil) {
        self.configurationsSet = configurationsSet
        self.mainController = target as? UIViewController
        
        Networker.request(Product.Request.getProductsOfSelectedTypes(offset: 1))
            .responseArray("data.products") { (response: Response<[Product], NSError>) in
                
            switch response.result {
            case .Success(let data):
                print("Success")
                print(data)
                self.products = data
            case .Failure(let error):
                print("Failure")
                print(error)
            }
                
            self.reloadData()
        }
    }
    
    // MARK: - Private Methods
    
    /**
        Update the view configurations, including layout, data sources, etc.
        
        - Parameter configurations: Configurations set to use.
    */
    private func updateConfigurationsSet(configurations: ProductsListConfigurationsSet) {
        switch configurations {
        case .All:
            self.productCellIdentifier = Identifiers.CollectionCells.Product
        case .Favorited:
            self.productCellIdentifier = Identifiers.CollectionCells.Favorited
        }
    }
    
    // MARK: - KVO
    
    private func addObservers() {
        // observe frame changes, so we reload layout on device rotation
        self.addObserver(self, forKeyPath: "frame", options: .New, context: nil)
    }
    
    private func removeObservers() {
        self.removeObserver(self, forKeyPath: "frame")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            self.collectionViewLayout.invalidateLayout()
        }
    }
    
}

// MARK: - Collection View Data Source

extension ProductsCollectionView: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(productCellIdentifier, forIndexPath: indexPath) as! ProductCollectionViewCell
        
        cell.product = self.products[indexPath.row]
        
        return cell
    }
    
}

// MARK: - Collection View Delegate

extension ProductsCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let margin: CGFloat = 10.0
        let columns: CGFloat = Utility.deviceOrientationIsPortrait() ? 2.0 : 3.0

        var dimension: CGFloat = 0.0
        
        if self.configurationsSet == .All {
            dimension = (self.bounds.size.width / columns) - (margin * (columns + 1) / columns)
        } else {
            dimension = self.bounds.size.width - 50.0
        }
        
        return CGSizeMake(dimension, dimension)
    }
    
}