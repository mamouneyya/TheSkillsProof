//
//  TutorialManager.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/7/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

enum TutorialStep: Int {
    case StepOne = 0
    case StepTwo
    
    var nextStep: TutorialStep {
        return TutorialStep(rawValue: self.rawValue + 1) ?? .StepOne
    }
}

class TutorialManager {

    // MARK: - Public Vars
    
    /// Singleton's class shared instance
    static let sharedInstance = TutorialManager()
    
    // MARK: - Lifecycle
    
    private init() {
        
    }
    
    // MARK: - Helpers
    
    func configurationsSetForStep(step: TutorialStep) -> TutorialConfigurationsSet {
        var configurationsSet = TutorialConfigurationsSet()
        
        switch step {
        case .StepOne:
            configurationsSet.title = Messages.Tutorial.StepOneTitle
            configurationsSet.asset = UIImage.TutorialAsset.Tutorial_1
            configurationsSet.buttonTitle = "Connect to my Souq account"

        case .StepTwo:
            configurationsSet.title = Messages.Tutorial.StepTwoTitle
            configurationsSet.asset = UIImage.TutorialAsset.Tutorial_2
            configurationsSet.buttonTitle = "Select my product types"
        }
        
        return configurationsSet
    }
    
}
