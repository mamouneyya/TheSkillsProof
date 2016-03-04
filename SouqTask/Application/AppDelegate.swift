//
//  AppDelegate.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/21/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit
import p2_OAuth2

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        setupAppearance()
        
        if Defaults[.InitialSetupDone] == false {
            changeRootToInitialSetup()
        }
    
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Helpers
    
    /**
        Shortcut to get the shared app delegate.

        - Returns: The shared application delegate as AppDelegate object.
    */
    class func sharedAppDelegate() -> AppDelegate? {
        return UIApplication.sharedApplication().delegate as? AppDelegate
    }
    
    // MARK: - Appearance

    /**
        Setup system components through appearance proxy.
    */
    func setupAppearance() {
        self.window?.backgroundColor = UIColor.whiteColor()
        
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = UIColor(red:38.0/255.0, green:41.0/255.0, blue:51.0/255.0, alpha:1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            //NSFontAttributeName: AppFont.SemiBold.Size(17)
        ]
        
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()

        UITableView.appearance().backgroundColor = UIColor(red: 0.9333, green: 0.9373, blue: 0.9373, alpha: 1.0)
        UITableView.appearance().separatorColor  = UIColor(red: 0.8353, green: 0.84, blue: 0.8399, alpha: 1.0)
        UITableView.appearance().separatorInset  = UIEdgeInsetsMake(0, 15, 0, 15)
        
        let tableCellSelectionView = UIView()
        tableCellSelectionView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        UITableViewCell.appearance().selectedBackgroundView = tableCellSelectionView
        UITableViewCell.appearance().tintColor = UIColor.whiteColor()
    }
    
    // MARK: - Deep Linking
    
    func applicationHandleOpenURL(url: NSURL) {
        if (url.host == "oauth-callback") {
            Authenticator.handleRedirectURL(url)
        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        applicationHandleOpenURL(url)
        return true
    }

    @available(iOS 9.0, *)
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        applicationHandleOpenURL(url)
        return true
    }
    
    // MARK: - Navigation

    /**
        Change window's root view controller to the selected destination.
        
        - Parameter destinationViewController:  The new root view controller to use.
        - Parameter animated:                   Whether the change should be animated.
        - Parameter fancy:                      If animated, passing true to this parameter will animate the 
                                                controller in a fancy way.
    */
    func changeRootViewController(destinationViewController: UIViewController, animated: Bool = true, fancy: Bool = false) {
        let snapshot:UIView = (self.window?.snapshotViewAfterScreenUpdates(true))!
        destinationViewController.view.addSubview(snapshot)
        
        self.window?.rootViewController = destinationViewController
        
        UIView.animateWithDuration(animated ? 0.3 : 0.0, animations: {() in
            snapshot.layer.opacity = 0;
            
            if fancy {
                snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }
            
            }, completion: {
                (value: Bool) in
                snapshot.removeFromSuperview()
        })
    }

    /**
         Change window's root view controller to the home (main tab bar controller).
     
         - Parameter animated:  Whether the change should be animated.
         - Parameter fancy:     If animated, passing true to this parameter will animate the controller in a fancy way.
    */
    func changeRootToHome(animated animated: Bool = true, fancy: Bool = false) {
        changeRootViewController(StoryboardScene.Main.instanciateMain(), animated: animated, fancy: fancy)
    }

    /**
         Change window's root view controller to the initial setup screen (on app first launch).
         
         - Parameter animated:  Whether the change should be animated.
         - Parameter fancy:     If animated, passing true to this parameter will animate the controller in a fancy way.
    */
    func changeRootToInitialSetup(animated animated: Bool = true, fancy: Bool = false) {
        changeRootViewController(StoryboardScene.Main.instanciateInitialSetupNavigation(), animated: animated, fancy: fancy)
    }

}
