//
//  Authenticator.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/27/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//
//  NOTE:   Honestly, I doubt this is working properly, but I am not able to test it since the site was
//          down for a while.

import UIKit
import p2_OAuth2

class Authenticator {

    // MARK: - Public Vars
    
    static let sharedInstance = Authenticator()

    /// Closure called on successful authentication on the main thread.
    static var onAuthorize: ((parameters: OAuth2JSON) -> Void)? {
        get {
            return Authenticator.sharedInstance.oauth2.onAuthorize
        }
        set {
            Authenticator.sharedInstance.oauth2.onAuthorize = newValue
        }
    }
    
    /// When authorization fails (if error is not nil) or is cancelled, this block is executed on the main thread.
    static var onFailure: ((error: ErrorType?) -> Void)? {
        get {
            return Authenticator.sharedInstance.oauth2.onFailure
        }
        set {
            Authenticator.sharedInstance.oauth2.onFailure = newValue
        }
    }
    
    // MARK: - Private Vars

    /// OAuth2 manager.
    private var oauth2: OAuth2CodeGrant
    
    /// OAuth2 settings.
    private let settings: OAuth2JSON = [
        "client_id"     : OAuthSettings.ClientId,
        "client_secret" : OAuthSettings.ClientSecret,
        "authorize_uri" : OAuthSettings.AuthorizeUri,
        "token_uri"     : OAuthSettings.AccessTokenUri,
        "scope"         : OAuthSettings.scope,
        "redirect_uris" : [OAuthSettings.RedirectUri],
        "keychain"      : true,
        "title"         : "Connect with Souq"
    ]
    
    // MARK: - Lifecycle

    private init() {
        oauth2 = OAuth2CodeGrant(settings: settings)
        oauth2.authConfig.authorizeEmbedded = false
        //oauth2.authConfig.authorizeContext = UIApplication.sharedApplication().keyWindow?.rootViewController
        oauth2.authConfig.secretInBody = true
        
        #if DEBUG
            oauth2.verbose = true
        #endif
    }
    
    // MARK: - Public Methods
    
    class func authorize() {
        sharedInstance.oauth2.authorize()
    }
    
    class func authorizeEmbeddedFrom(context: AnyObject) {
        sharedInstance.oauth2.authorizeEmbeddedFrom(context)
    }
    
    class func handleRedirectURL(redirectURL: NSURL) {
        sharedInstance.oauth2.handleRedirectURL(redirectURL)
    }
    
}
