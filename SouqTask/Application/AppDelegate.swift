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
        // Override point for customization after application launch.
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
    
    class func sharedAppDelegate() -> AppDelegate? {
        return UIApplication.sharedApplication().delegate as? AppDelegate
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

    func changeRootViewController(destinationViewController: UIViewController, fancyAnimation: Bool = false) {
        let snapshot:UIView = (self.window?.snapshotViewAfterScreenUpdates(true))!
        destinationViewController.view.addSubview(snapshot)
        
        self.window?.rootViewController = destinationViewController
        
        UIView.animateWithDuration(0.3, animations: {() in
            snapshot.layer.opacity = 0;
            
            if fancyAnimation {
                snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }
            
            }, completion: {
                (value: Bool) in
                snapshot.removeFromSuperview()
        })
    }

}

