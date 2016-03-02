//
//  Router.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/29/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit
import Alamofire

/**
 Types adopting the `RequestConfigurations` protocol can be used to intialize Router, which is used to construct URL requests.
 */
public protocol RequestConfigurations {
    /// The URL result tuple, containing both request path and parameters
    var result: (path: String, parameters: [String: AnyObject]?) { get }
    /// The URL request method (e.g. .Get, .Post, etc.)
    var method: Alamofire.Method { get }
    /// The URL request encoding (e.g. .URL, .JSON, etc.)
    var encoding: ParameterEncoding { get }
    /// Whether the request needs to pass OAuth token in header
    var needsAuthentication: Bool { get }
}

/**
 A router, before passing to Networker method, should be initialized with a `RequestConfigurations` protocol-conforming object, which is used to construct URL requests.
 */
struct Router: URLRequestConvertible {
    
    // MARK: - Private Vars
    
    /// Our `RequestConfigurations` protocol-conforming object
    private var requestConfigurations: RequestConfigurations

    // MARK: - Lifecycle
    
    /// The only supported initializer, so we guarantee existence of needed configurations
    init(_ requestConfigurations: RequestConfigurations) {
        self.requestConfigurations = requestConfigurations
    }

    // MARK: - URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: RouterConfigurations.baseURLString)!
        
        // cache data using NSURLCache
        // TODO this can be implemented in a better way (e.g. using CoreData)
        let cachePolicy: NSURLRequestCachePolicy = Networker.isReachable ? .ReloadIgnoringLocalCacheData : .ReturnCacheDataElseLoad
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(requestConfigurations.result.path), cachePolicy: cachePolicy, timeoutInterval: 30)
        // override the cache policy in the server's response header
        // @ref http://stackoverflow.com/questions/27785693/alamofire-nsurlcache-is-not-working
        URLRequest.addValue("private", forHTTPHeaderField: "Cache-Control")
        
        URLRequest.HTTPMethod = requestConfigurations.method.rawValue
        
        //if let token = Router.userToken where needsAuthentication {
            //URLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        //}
        
        // add app_id and app_secret to the parameters
        var requestParameters = requestConfigurations.result.parameters ?? [String: AnyObject]()
            requestParameters["app_id"]     = OAuthSettings.ClientId
            requestParameters["app_secret"] = OAuthSettings.ClientSecret
        
        return requestConfigurations.encoding.encode(URLRequest, parameters: requestParameters).0
    }

}
