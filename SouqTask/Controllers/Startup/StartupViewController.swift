//
//  LoginTableViewController.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/23/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

class StartupViewController: BaseViewController {

    // MARK: - Outlets
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Authenticator.onAuthorize = { parameters in
            print("Did authorize with parameters: \(parameters)")
            
            // TODO: ...
            
            AppDelegate.sharedAppDelegate()?.changeRootViewController(StoryboardScene.Main.instanciateMain())
        }
        
        Authenticator.onFailure = { error in
            if let error = error {
                print("Authorization went wrong: \(error)")
            } else {
                print("Authorization went wrong.")
            }

            // TODO: ...
            
            AppDelegate.sharedAppDelegate()?.changeRootViewController(StoryboardScene.Main.instanciateMain())
        }
        
        Authenticator.authorizeEmbeddedFrom(self.navigationController!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
