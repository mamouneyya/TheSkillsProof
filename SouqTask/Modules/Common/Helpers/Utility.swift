//
//  Utility.swift
//  Open Souq Assignment
//
//  Created by Ma'moun Diraneyya on 11/4/15.
//  Copyright © 2015 Mamouneyya. All rights reserved.
//

import UIKit
import AASquaresLoading

class Utility {

    // MARK: Vars
    
    // singleton implementation
    static let sharedInstance = Utility()
    
    // MARK: Lifecycle
    
    //This prevents others from using the default '()' initializer for this class.
    private init() {}
    
    // MARK: - Loading Indicator
    
    /**
        Show loading indicator in the selected view.
    
        - parameter view: The view to add the indicator to.
    */
    class func showLoadingHUD(view: UIView) {
        view.squareLoading.start(0.0)
    }

    /**
        Hide loading indicator that was previously added through `showLoadingHUD()`.
         
        - parameter view: The view to remove the indicator from.
    */
    class func hideLoadingHUD(view: UIView) {
        view.squareLoading.stop(0.0)
    }
    
    // MARK: - Alerts

    /**
        Show alert message from a specific error code.
        
        - parameter errorCode: Error code to use its friendlyMessage for the alert message.
        - parameter target:    The view controller to present the alert from. If nil, the root view controller
                               of the current active window will be used.
    */
    class func showMessageAlert(errorCode: Error.Code, target: UIViewController? = nil) {
        showMessageAlert(errorCode.friendlyMessage, target: target)
    }
    
    /**
        Show alert message.
         
        - parameter message: Message to show in the alert.
        - parameter target:  The view controller to present the alert from. If nil, the root view controller
                             of the current active window will be used.
    */
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
    
    /**
        Show alert message with confirmation button (Yes, Cancel).
         
        - parameter message: Message to show in the alert.
        - parameter target:  The view controller to present the alert from. If nil, the root view controller
                             of the current active window will be used.
        - parameter action:  Closure to run in case user tapped `Yes`.
    */
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
