//
//  Utility.swift
//  Open Souq Assignment
//
//  Created by Ma'moun Diraneyya on 11/4/15.
//  Copyright © 2015 Mamouneyya. All rights reserved.
//

import UIKit
import AASquaresLoading

class Utility: NSObject {

    // MARK: Vars
    
    // singleton implementation
    static let sharedInstance = Utility()
    
    // MARK: Lifecycle
    
    //This prevents others from using the default '()' initializer for this class.
    private override init() {}
    
    // MARK: - Loading Indicator
    
    class func showLoadingHUD(view: UIView) {
        view.squareLoading.start(0.0)
    }
    
    class func hideLoadingHUD(view: UIView) {
        view.squareLoading.stop(0.0)
    }
    
    // MARK: - Alerts
    
    class func showMessageAlert(message: String, target: UIViewController? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(okAction);
        
        if let target = target {
            target.presentViewController(alert, animated: true, completion: nil)
        } else {
            UIApplication.sharedApplication().windows[0].rootViewController?.presentViewController(alert, animated:true, completion:nil)
        }
    }
    
    class func showConfirmationAlert(message: String, target: UIViewController? = nil, action: () -> ()) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Yes", style: .Default) { UIAlertAction in
            action()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        if let target = target {
            target.presentViewController(alert, animated: true, completion: nil)
        } else {
            UIApplication.sharedApplication().windows[0].rootViewController?.presentViewController(alert, animated:true, completion:nil)
        }
    }
    
}
