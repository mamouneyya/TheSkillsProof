//
//  LoginTableViewController.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/23/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//
//  NOTE:   The idea from this controller is to extend the launch screen and make any logic we need behind
//          the scenes before going to the main controller. From user point of view, they're all launch screen.

import UIKit

class StartupViewController: BaseViewController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Private
    
    // MARK: - Initialize
    
    private func initialize() {
        // TODO needs more sophisticated handling
        if !Networker.isReachable {
            goToFail()
            return
        }
        
        // look if user initially setup the app after install
        if Defaults[.InitialTutorialDone] == false {
            AppDelegate.sharedAppDelegate()?.changeRootToInitialSetup()
        } else {
            AppDelegate.sharedAppDelegate()?.changeRootToHome()
        }
    }
    
    // MARK: - Navigation
    
    /**
        Navigates to the fail view controller.
    */
    private func goToFail() {
        let failController = StoryboardScene.Main.instanciateFail()
        self.navigationController?.pushViewController(failController, animated: true)
    }
    
}
