//
//  TutorialViewController.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/7/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

class TutorialViewController: BaseViewController {

    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    
    // MARK: - Public Vars

    /// Active step to use for filling current screen's data.
    var activeStep = TutorialStep.StepOne
    
    // MARK: - Private Vars
    
    /// Tutorial manager object, to get the configurations from.
    private let manager = TutorialManager.sharedInstance
    
    private typealias actionHandler = () -> ()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private

    // MARK: - Initialize
    
    private func initialize() {
        let configurations = self.manager.configurationsSetForStep(self.activeStep)
        
        self.titleLabel.text = configurations.title
        self.imageView.image = configurations.asset?.image
        self.actionButton.setTitle(configurations.buttonTitle, forState: .Normal)
    }
    
    // MARK: - Helpers
    
    /**
        Handles OAuth2 stuff, and move to the next step if authorization succeeded.
    
        - Note: We actually go in both ways currently, as nothing really depends on the token.
    */
    private func handleAuth() {
        Authenticator.onAuthorize = { parameters in
            #if DEBUG
                print("Did authorize with parameters: \(parameters)")
            #endif
            
            self.goToNextStep()
        }
        
        Authenticator.onFailure = { error in
            #if DEBUG
                if let error = error {
                    print("Authorization went wrong: \(error)")
                } else {
                    print("Authorization went wrong.")
                }
            #endif
            
            //self.goToFail()
            self.goToNextStep()
        }

        Authenticator.authorizeEmbeddedFrom(self)
    }
    
    /**
        Navigates to the product types selection controller, as user needs to configure them before access the app after a fresh install.
    */
    private func handleInitialConfigurations() {
        let productTypesController = StoryboardScene.Main.instanciateProductTypes()
        let productTypesInNavigationController = UINavigationController(rootViewController: productTypesController)
        
        AppDelegate.sharedAppDelegate()?.changeRootViewController(productTypesInNavigationController)
    }
    
    // MARK: - Actions
    
    @IBAction func actionButtonTapped(sender: UIButton) {
        switch self.activeStep {
        case .StepOne:
            self.handleAuth()
            
        case .StepTwo:
            self.handleInitialConfigurations()
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    /**
        Navigates to the fail view controller.
    */
    private func goToFail() {
        let failController = StoryboardScene.Main.instanciateFail()
        AppDelegate.sharedAppDelegate()?.changeRootViewController(failController)
    }
    
    /**
        Goes to the next step of the tutorial.
    */
    private func goToNextStep() {
        let nextStepController = StoryboardScene.Main.instanciateTutorial()
            nextStepController.activeStep = self.activeStep.nextStep
        let nextStepInNavigationController = UINavigationController(rootViewController: nextStepController)

        AppDelegate.sharedAppDelegate()?.changeRootViewController(nextStepInNavigationController)
    }

}
