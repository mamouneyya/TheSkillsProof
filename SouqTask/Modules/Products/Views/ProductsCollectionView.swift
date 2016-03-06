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
    func cellConfigurationsSet() -> ProductCellConfigurationsSet {
        switch self {
        case .All:
            return ProductCellConfigurationsSet.All
        case .Favorited:
            return ProductCellConfigurationsSet.Favorited
        }
    }
}

class ProductsCollectionView: UICollectionView {

    // MARK: - Public Vars
    
    /// Configurations set of the data / appearance
    var configurationsSet = ProductsListConfigurationsSet.All {
        didSet {
            updateConfigurationsSet(configurationsSet)
        }
    }
    
    // MARK: - Private Vars
    
    /////////////
    // DATA STUFF
    /////////////
    
    /// Data models for the table view data source to use
    private var products = [Product]()
    
    /// Table's cells identifier for the table view data source to use
    private var productCellIdentifier = ""
    
    /// Main view controller, to use in case of navigation action
    private var mainController: UIViewController?
    
    /// Indicates that the collection view needs reload next time it appears (Most probably favorite statuses got changed)
    private var reloadOnNextAppear = false
    
    ///////////////////
    // PAGINATION STUFF
    ///////////////////
    
    /// Current page / offset.
    private var currentOffset = 1
    
    // MARK: - Lifecycle
    
    deinit {
        removeObservers()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        initialize()
    }

    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        
        // when flag raised to reload data, we look for the current configurations set,
        // if All products, then simply calling `reloadData()` will refresh products 
        // favorite statuses, as the new values will be read from our local DB. However,
        // in case of Favorited products, we need to fetch the data itsef from our DB again,
        // before calling reloadData().
        if newWindow != nil && self.reloadOnNextAppear {
            if self.configurationsSet == .All {
                self.reload()
            } else if self.configurationsSet == .Favorited {
                self.getFavoritedProducts()
            }
            
            // reset the flag
            self.reloadOnNextAppear = false
        }
    }
    
    // MARK: - Initializing

    /**
        Initialize everything before really using the components (e.g. register cell nibs, initialize layouts, etc.).
    */
    func initialize() {
        registerCellNibs()
        
        initializeCollectionView()
    }
    
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
            let spacing: CGFloat = self.configurationsSet == .Favorited ? 20.0 : 10.0
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
        
        self.backgroundColor = UIColor.whiteColor()
        self.bounces = true
        self.alwaysBounceVertical = true
    }
    
    /**
        Add infinite scrolling capability to the collection view, with the action to fire `getMoreProducts('////'//)`.
    */
    func addInfiniteScroll() {
        self.addInfiniteScrollWithHandler { (scrollView) -> Void in
            self.getMoreProducts()
        }
    }
    
    // MARK: - Public Methods
    
    // MARK: - Data
    
    /**
        This method internally calls API methods and configure everything so the data gets fetched and displayed as it should be for the desired configurations.
        
        - Parameter configurationsSet:  Desired configuration set to use for configuring layout / API calls, etc.
        - Parameter target:             The view controller to show the collection view from, in case of needing
                                        any navigation action. If nil, some actions, if exists, may lost its 
                                        expected behaviours.
    */
    func loadData(configurationsSet configurationsSet: ProductsListConfigurationsSet, target: AnyObject? = nil) {
        self.configurationsSet = configurationsSet
        self.mainController    = target as? UIViewController
        
        if configurationsSet == .Favorited {
            getFavoritedProducts()
        } else if configurationsSet == .All {
            getProducts()
        }
    }
    
    /**
        This method is designed to be called from Favorited product cell, to delete a specific product from our favorites DB. After making sure the data got updated successfully, the method removes product's cell from the collection view with a nice animation.
        
        - Parameter cell: Favorited product cell to delete its product from favorites.
     
        - NOTE: This method should never be called from any cell other than Favorited product cell.
    */
    func deleteFavoritedProductInCell(cell: ProductCollectionViewCell) {
        guard self.configurationsSet == .Favorited else {
            print("Warning: This method should NOT be used with collection view other than favorites.")
            return
        }
        
        // get cell's index path
        if let indexPath = self.indexPathForCell(cell) {
            if indexPath.row < self.products.count {
                let product = self.products[indexPath.row]
                
                FavoritesManager.asyncRemoveProductFromFavorite(product) { (_, error) -> () in
                    guard error == nil else { return }
                    
                    self.products.removeAtIndex(indexPath.row)
                    
                    // send notifications to All products collection view, so it also updates the product's
                    // favorite status accordingly. This guarantees consistency between both collection views.
                    NSNotificationCenter.defaultCenter().postNotificationName(Observers.ReloadAllProducts, object: nil)
                    
                    // update view in main thread
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.deleteItemsAtIndexPaths([indexPath])
                    }
                }
            }
        }
    }
    
    /**
        This method is designed to be called from All product cell when update happens to one of the product favorite status, to update Favorites collection view cells accordingly.
    */
    func refreshProductsFavoriteStatus() {
        NSNotificationCenter.defaultCenter().postNotificationName(Observers.ReloadFavoritedProducts, object: nil)
    }
    
    // MARK: - Private Methods
    
    // MARK: - API
    
    /**
        Get an array of all products from the server, paginated by the offset parameter. It adds the results array, is succeeded to the controller products array, and fires reloadTableView().
        
        - Parameter offset: The current page / offset. If not passed, default value is Zero.
    */
    private func getProducts(offset: Int = 1) {
        if offset == 1 {
            Utility.showLoadingHUD(self)
        }
        
        Networker.request(Product.Request.getProductsOfSelectedTypes(offset: offset))
            .responseArray("data.products") { (response: Response<[Product], NSError>) in

                if offset == 1 {
                    Utility.hideLoadingHUD(self)
                }
                
                switch response.result {
                case .Success(let data):
                    if offset == 1 {
                        self.products.removeAll()
                        self.products = data
                        
                        self.reloadData()
                        
                    } else {
                        var indexPathsToInsert = [NSIndexPath]()
                        for rowOffset in 0 ..< data.count {
                            let row = self.products.count + rowOffset
                            indexPathsToInsert.append(NSIndexPath(forRow: row, inSection: 0))
                        }
                        
                        self.products += data
                        
                        self.performBatchUpdates({ () -> Void in
                            self.insertItemsAtIndexPaths(indexPathsToInsert)
                          
                            }, completion: { (finished) -> Void in
                                self.finishInfiniteScroll()
                        })
                    }

                case .Failure(let error):
                    print("Failure")
                    print(error)
                }
        }
    }
    
    /**
        Get all favorited products stored locally in our DB, the method automatically fires reloadTableView() when fetches results.
    */
    private func getFavoritedProducts() {
        Utility.showLoadingHUD(self)
        
        FavoritesManager.asyncGetAllProductsInFavorite { (objects, error) -> () in
            if let objects = objects {
                self.products = objects
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    Utility.hideLoadingHUD(self)
                    self.reload()
                }
            }
        }
    }
    
    /**
        Fetch more results from the server until they're all fetched.
    */
    private func getMoreProducts() {
        self.currentOffset += 1
        getProducts(self.currentOffset)
    }
    
    /**
        Update the view configurations, including layout, data sources, etc.
        
        - Parameter configurations: Configurations set to use.
    */
    private func updateConfigurationsSet(configurations: ProductsListConfigurationsSet) {
        switch configurations {
        case .All:
            self.productCellIdentifier = Identifiers.CollectionCells.Product
            addInfiniteScroll()
            
        case .Favorited:
            self.productCellIdentifier = Identifiers.CollectionCells.Favorited
        }
        
        // initialize layout at this stage, as it depends on the selected configurations set
        addObservers()
        initializeLayout()
    }
    
    // MARK: - Helpers
    
    /**
        TODO    Before reload collection view, this function shoud check for cases like if we have no items to
                display whether because of an error while fetching data from server, or simply because we have 
                no items currently, etc.
    */
    private func reload() {
        self.reloadData()
    }

    // MARK: - Observers
    
    /**
        Add our observers (both KVO & notifications based).
    
        - NOTE: This method should be called in a place that is guaranteed to get the correct value of
                `configurationsSet`, as some observers depend on it to decide what events to register.
    */
    private func addObservers() {
        addKVOObservers()
        addNotificationObservers()
    }
    
    /**
        Remove all class observers.
    */
    private func removeObservers() {
        removeKVOObservers()
        removeNotificationObservers()
    }
    
    // MARK: - KVO
    
    private func addKVOObservers() {
        // observe frame changes, so we reload layout on device rotation
        self.addObserver(self, forKeyPath: "frame", options: .New, context: nil)
    }
    
    private func removeKVOObservers() {
        self.removeObserver(self, forKeyPath: "frame")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            self.collectionViewLayout.invalidateLayout()
        }
    }
    
    // MARK: - Notifications
    
    private func addNotificationObservers() {
        if self.configurationsSet == .All {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "onReloadNotification:", name: Observers.ReloadAllProducts, object: nil)

        } else if self.configurationsSet == .Favorited {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "onReloadNotification:", name: Observers.ReloadFavoritedProducts, object: nil)
        }
    }
    
    private func removeNotificationObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @objc private func onReloadNotification(notification: NSNotification) {
        // raise a flag to reload on next appear
        self.reloadOnNextAppear = true
    }
    
    // MARK: - Navigation
    
    /**
        Navigate to product detailed controller.
        
        - Parameter product:    Product to go to its detailed screen.
        - Parameter cell:       Cell object so the detailed can use cell's methods to update favorite statuses.
    */
    private func goToProduct(product: Product, cell: ProductCollectionViewCell?) {
        let productController = StoryboardScene.Main.instanciateProduct()
            productController.product = product
            productController.sourceCell = cell
        
        self.mainController?.navigationController?.pushViewController(productController, animated: true)
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
        
        cell.mainCollectionView = self
        cell.product = self.products[indexPath.row]
        
        return cell
    }
    
}

// MARK: - Collection View Delegate

extension ProductsCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < self.products.count {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ProductCollectionViewCell
            goToProduct(self.products[indexPath.row], cell: cell)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let margin: CGFloat = 10.0
        let columns: CGFloat = Utility.deviceOrientationIsPortrait() ? 2.0 : 3.0

        var width: CGFloat = 0.0
        var height: CGFloat?
        
        if self.configurationsSet == .All {
            width = (self.bounds.size.width / columns) - (margin * (columns + 1) / columns)
        } else {
            width = self.bounds.size.width - 40.0
            height = 135.0
        }
        
        return CGSizeMake(width, height ?? width)
    }
    
}