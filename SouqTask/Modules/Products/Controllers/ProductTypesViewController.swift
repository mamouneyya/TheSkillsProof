//
//  ProductTypesTableViewController.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/4/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

class ProductTypesViewController: BaseViewController {

    // MARK: - Outlets
    
    /// Product types list's table view.
    @IBOutlet weak var tableView: UITableView!
    
    /// Next Button.
    @IBOutlet weak var nextButton: UIButton!
    
    /// Table's footer view to be shown while loading more results, created when needed.
    lazy var footerView: UIView = {
        let view = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 100))

        self.footerActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.footerActivityIndicator!.center = view.center
        self.footerActivityIndicator!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.footerActivityIndicator!.translatesAutoresizingMaskIntoConstraints = true
        
        view.addSubview(self.footerActivityIndicator!)
        
        return view
    }()

    /// Reference to activity indicator of load more view in table's footer.
    var footerActivityIndicator: UIActivityIndicatorView?
    
    // MARK: - Private Vars
    
    /////////////
    // DATA STUFF
    /////////////

    /// All server returned product types.
    private var productTypes = [ProductType]()

    // NOTE The reason this is dictionary rather than an array, 
    // is to delete unselected items from it effeiently, without
    // an array iteration
    /// User selected product types as dictionary: [Type ID: Type].
    private var selectedProductTypesMap = [String: ProductType]()

    /// More intuitive accessor for selected product types.
    private var selectedProductTypes: [ProductType] {
        return [ProductType](selectedProductTypesMap.values)
    }

    ///////////////////
    // PAGINATION STUFF
    ///////////////////
    
    /// Current page / offset.
    private var currentOffset = 1
    
    /// Whether we're currently fetching more results.
    private var loadingMore = false {
        didSet {
            // if true, show loading more indicator in footer
            if loadingMore {
                self.tableView.tableFooterView = self.footerView
                self.footerActivityIndicator?.startAnimating()
            } else {
                self.tableView.tableFooterView = nil
                self.footerActivityIndicator?.stopAnimating()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getProductTypes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - API
    
    /**
        Get an array of all product types from the server, paginated by the offset parameter. It adds the results array, is succeeded to the controller productTypes array, and fires reloadTableView().
        
        - Parameter offset: The current page / offset. If not passed, default value is Zero.
    */
    private func getProductTypes(offset: Int = 1) {
        if offset > 1 {
            self.loadingMore = true
        }
        
        #if DEBUG
            print("getProductTypes(offset: \(offset))")
        #endif
        
        Networker.request(Product.Request.getProductTypes(offset: offset)).responseArray {
            (response: Response<[ProductType], NSError>) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                switch response.result {
                case .Success(let data):
                    if offset == 1 {
                        self.productTypes.removeAll()
                        self.productTypes = data

                        self.reloadTableView()
                        
                    } else {
                        var indexPathsToInsert = [NSIndexPath]()
                        for rowOffset in 0 ..< data.count {
                            let row = self.productTypes.count + rowOffset
                            indexPathsToInsert.append(NSIndexPath(forRow: row, inSection: 0))
                        }
                        
                        self.productTypes += data
                        
                        self.tableView.beginUpdates()
                        self.tableView.insertRowsAtIndexPaths(indexPathsToInsert, withRowAnimation: .Fade)
                        self.tableView.endUpdates()
                    }
                case .Failure(_): ()
                }
                
                self.loadingMore = false
            })
        }
    }
    
    /**
        Ask the server for more product types until we fetch them all. This should be called when accessing the bottom of tale view.
    */
    private func getMoreProductTypes() {
        guard self.loadingMore == false else { return }

        self.currentOffset += 1
        getProductTypes(self.currentOffset)
    }
    
    // MARK: - Helpers
    
    /**
        TODO Before reload table view, this function shoud check for cases like if we have no items to display whether because of an error while fetching data from server, or simply because we have no items currently, etc.
    */
    private func reloadTableView() {
        self.tableView.reloadData()
    }
    
    /**
        Possible operations to selected product types.

        - Select: Add to selection.
        - Deselect: Remove from selection.
    */
    enum UpdateSelectionOperation {
        case Select
        case Deselect
    }
    
    /**
        Add product type to selected product types.
    */
    private func addProductTypeToSelection(productType: ProductType) {
        updateProductTypeInSelection(productType, operation: .Select)
    }

    /**
        Remove product type from selected product types.
    */
    private func removeProductTypeFromSelection(productType: ProductType) {
        updateProductTypeInSelection(productType, operation: .Deselect)
    }
    
    /**
        The actual implementation to add / remove product type to / from selected product types.
    */
    private func updateProductTypeInSelection(productType: ProductType, operation: UpdateSelectionOperation) {
        switch operation {
        case .Select:
            self.selectedProductTypesMap[productType.id] = productType
        case .Deselect:
            self.selectedProductTypesMap.removeValueForKey(productType.id)
        }
        
        //#if DEBUG
            //print("====\n\nMAP:\n")
            //print(selectedProductTypesMap)
            //print("====\n\nARRAY:\n")
            //print(selectedProductTypes)
        //#endif
    }

    /**
        Save / Update user product types on disk. (for now they're saved in UserDefaults.)
    */
    private func saveSelectedProductTypes() {
        func extractedProductTypeIds(productTypes: [ProductType]) -> [Int] {
            var productTypeIds = [Int]()
            for productType in productTypes {
                productTypeIds.append(Int(productType.id)!)
            }
            
            return productTypeIds
        }
        
        Defaults[.UserProductTypeIds] = extractedProductTypeIds(self.selectedProductTypes)
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonTapped(sender: AnyObject) {
        saveSelectedProductTypes()
        Defaults[.InitialSetupDone] = true
        goToHome()
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    func goToHome() {
        AppDelegate.sharedAppDelegate()?.changeRootToHome(animated: true, fancy: true)
    }

}

// MARK: - Table View Data Source

extension ProductTypesViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productTypes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Identifiers.TableCells.ProductType, forIndexPath: indexPath) as! ProductTypeTableViewCell
        
        // configure cell
        cell.productType = self.productTypes[indexPath.row]
        
        return cell
    }
    
}

// MARK: - Table View Delegate

extension ProductTypesViewController: UITableViewDelegate {
 
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        addProductTypeToSelection(self.productTypes[indexPath.row])
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        removeProductTypeFromSelection(self.productTypes[indexPath.row])
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // implement load more
        // TODO this should be implemented in a reusable way!
        if self.productTypes.count > 0 && indexPath.row == self.productTypes.count - 5 {
            getMoreProductTypes()
        }
    }
    
}