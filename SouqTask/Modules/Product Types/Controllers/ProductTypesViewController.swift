//
//  ProductTypesTableViewController.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/4/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

/**
    Available configurations set.

    - InitialSetup: Initial app setup screen.
    - Settings: Edit selected types setting screen.
*/
enum ProductTypesControllerConfigurationsSet {
    case InitialSetup
    case Settings
}

class ProductTypesViewController: BaseViewController {

    // MARK: - Outlets
    
    /// Product types list's table view.
    @IBOutlet weak var tableView: UITableView!
    
    /// Save Button.
    @IBOutlet weak var saveButton: UIButton!

    /// Save Button height constraint.
    @IBOutlet weak var saveButtonHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Public Vars
    
    var configurationsSet = ProductTypesControllerConfigurationsSet.InitialSetup
    
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
    private var selectedProductTypeIdsMap = [String: Bool]()

    /// More intuitive accessor for selected product types (Read-Only).
    private var selectedProductTypeIds: [String] {
        return [String](selectedProductTypeIdsMap.keys)
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
    
    /// Table's footer view to be shown while loading more results, created when needed.
    private lazy var footerView: UIView = {
        let view = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 100))
        
        self.footerActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.footerActivityIndicator!.center = view.center
        self.footerActivityIndicator!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.footerActivityIndicator!.translatesAutoresizingMaskIntoConstraints = true
        
        view.addSubview(self.footerActivityIndicator!)
        
        return view
    }()
    
    /// Reference to activity indicator of load more view in table's footer.
    private var footerActivityIndicator: UIActivityIndicatorView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        getProductTypes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Methods
    
    // MARK: - Initialize
    
    private func initialize() {
        // update views for the selected configurations set
        updateConfigurationsSet(self.configurationsSet)
    }
    
    // MARK: - API
    
    /**
        Get an array of all product types from the server, paginated by the offset parameter. It adds the results array, is succeeded to the controller productTypes array, and fires reloadTableView().
        
        - Parameter offset: The current page / offset. If not passed, default value is Zero.
    */
    private func getProductTypes(offset: Int = 1) {
        if offset > 1 {
            self.loadingMore = true
        } else {
            Utility.showLoadingHUD(self.view)
        }

        Networker.request(ProductType.Request.getProductTypes(offset: offset)).responseArray {
            (response: Response<[ProductType], NSError>) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                switch response.result {
                case .Success(let data):
                    if offset == 1 {
                        self.productTypes.removeAll()
                        self.productTypes = data

                        Utility.hideLoadingHUD(self.view)
                        
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
        Configure views according to the passed configurations set.
        
        - Parameter configurationsSet: The configurations set to use.
    */
    private func updateConfigurationsSet(configurationsSet: ProductTypesControllerConfigurationsSet) {
        switch configurationsSet {
        case .InitialSetup:
            // initially hide save button, until we select at least one type
            hideSaveButtonIfNoSelection(false)
            
            self.saveButton.setTitle("Next", forState: .Normal)
            self.saveButton.setTitle("Next", forState: .Selected)

            self.navigationItem.leftBarButtonItem = nil
            
        case .Settings:
            self.saveButton.setTitle("Save", forState: .Normal)
            self.saveButton.setTitle("Save", forState: .Selected)
            
            self.selectedProductTypeIdsMap.removeAll()
            
            if let savedTypeIds = Defaults[.UserProductTypeIds] {
                for savedTypeId in savedTypeIds {
                    self.selectedProductTypeIdsMap[savedTypeId] = true
                }
            }
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.Asset.Close.image, style: .Plain, target: self, action: "closeBarButtonTapped:")
        }
    }
    
    /**
        TODO    Before reload table view, this function shoud check for cases like if we have no items to display
                whether because of an error while fetching data from server, or simply because we have no items
                currently, etc.
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
            self.selectedProductTypeIdsMap[productType.id] = true
        case .Deselect:
            self.selectedProductTypeIdsMap.removeValueForKey(productType.id)
        }
    }

    /**
        Save / Update user product types on disk. (for now they're saved in UserDefaults.)
    */
    private func saveSelectedProductTypes() {
        Defaults[.UserProductTypeIds] = self.selectedProductTypeIds
    }
    
    /**
        Returns whether the passed product type is already saved in our records.
        
        - Parameter productType: Product type to look for.

        - Returns: Whether the passed product type is already saved in our records.
    */
    private func savedProductType(productType: ProductType) -> Bool {
        if let savedTypeIds = Defaults[.UserProductTypeIds] {
            for savedTypeId in savedTypeIds {
                if savedTypeId == productType.id {
                    return true
                }
            }
        }
        
        return false
    }
    
    /**
        Show save button if user selected at least one item. Hide otherwise.
        
        - Parameter animated: If the show / hiding should be made with animation.
    */
    private func hideSaveButtonIfNoSelection(animated: Bool = true) {
        let show = (self.tableView.indexPathsForSelectedRows?.count ?? 0) > 0
        let finalHeight: CGFloat = show ? 50.0 : 0.0
        
        // if already got the final state, do nothing
        if self.saveButtonHeightConstraint.constant == finalHeight {
            return
        }
        
        self.view.layoutIfNeeded()
        
        self.saveButtonHeightConstraint.constant = finalHeight
        
        UIView.animateWithDuration(animated ? 0.55 : 0.0, delay: 0.0, usingSpringWithDamping: 0.45,
            initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        saveSelectedProductTypes()
        
        if self.configurationsSet == .InitialSetup {
            Defaults[.InitialTutorialDone] = true
            goToHome()
        } else {
            dismiss()
        }
    }
    
    @IBAction func closeBarButtonTapped(sender: UIBarButtonItem) {
        dismiss()
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    /**
        Navigate to home view controller.
    */
    private func goToHome() {
        AppDelegate.sharedAppDelegate()?.changeRootToHome(animated: true, fancy: true)
    }
    
    /**
        Dismisses the view controller when presented modally.
    */
    private func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        
        // initially select saved types
        let productId = self.productTypes[indexPath.row].id
        if self.selectedProductTypeIdsMap[productId] == true {
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            tableView.delegate?.tableView?(tableView, didSelectRowAtIndexPath: indexPath)
        }
        
        return cell
    }
    
}

// MARK: - Table View Delegate

extension ProductTypesViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        addProductTypeToSelection(self.productTypes[indexPath.row])
        hideSaveButtonIfNoSelection()
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        removeProductTypeFromSelection(self.productTypes[indexPath.row])
        hideSaveButtonIfNoSelection()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // implement load more
        // TODO this should be implemented in a reusable way!
        if self.productTypes.count > 0 && indexPath.row == self.productTypes.count - 5 {
            getMoreProductTypes()
        }
    }
    
}