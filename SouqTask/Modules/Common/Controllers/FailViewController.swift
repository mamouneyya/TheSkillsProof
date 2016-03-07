//
//  FailViewController.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/7/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

class FailViewController: BaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    // MARK: - Public Vars
    
    /// Error message to the show to the user.
    var errorMessage = ""
    
    // TODO this could be converted to a closure to spcify the
    // retry button action, and if nil, then we automaticaly hide it
    /// If we need a retry button.
    var showRetry = true
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    // MARK: - Initialize
    
    private func initialize() {
        self.errorMessageLabel.text = self.errorMessage
        self.retryButton.hidden = showRetry == false
    }
    
    // MARK: - Actions
    
    @IBAction func retryButtonTapped(sender: UIButton) {
        if Networker.isReachable {
            // here should go some logic to retry the process from StartupViewController.
            // one of the ideas I have is to configure StartupViewController to take its image
            // dynamically, and pass a screenshot from the current controller to it in a way it
            // shows that image while do the needed processing (instead of showing the launch 
            // screen, as it does now).
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
