//
//  Constants.swift
//  Open Souq Assignment
//
//  Created by Ma'moun Diraneyya on 11/4/15.
//  Copyright © 2015 Mamouneyya. All rights reserved.
//

import UIKit
import p2_OAuth2
import OAuthSwift

// MARK: - Networking

struct API {
    static let Base = "https://api.souq.com/v1"
}

struct OAuthSettings {
    static let ClientId       = "20455500"
    static let ClientSecret   = "a3rIAIObv3PSIIKncpEj"
    static let AuthorizeUri   = "https://api.souq.com/oauth/authorize"
    static let AccessTokenUri = "https://api.souq.com/oauth/access_token"
    static let RedirectUri    = "souq-skills-test://oauth-callback"
    static let scope          = "OAuth2.0,discovery,customer_profile"
}

// MARK: - Reusable Views

struct Identifiers {
    static let productCell    = "ListProduct"
    static let favoritedCell  = "FavoritedProduct"
}

// MARK: - Appearance Assets

struct AppColor {
    static let mainTint = UIColor(red:0.0/255.0, green:138.0/255.0, blue:255.0/255.0, alpha:1.0)
}

// MARK: - Performance Logging Helpers

var startTime = NSDate()
func TICK(){ startTime =  NSDate() }
func TOCK(function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) {
    print("\(function) Time: \(startTime.timeIntervalSinceNow)\nLine:\(line) File: \(file)")
}