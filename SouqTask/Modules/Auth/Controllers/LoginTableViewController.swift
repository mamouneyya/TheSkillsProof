//
//  LoginTableViewController.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/23/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

class LoginTableViewController: BaseTableViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
    
    }
    
}

// MARK: - Table View Delegate

extension LoginTableViewController {
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.view.bounds.height / 1.8
        }
        
        return 50
    }
    
}
