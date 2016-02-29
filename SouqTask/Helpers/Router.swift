//
//  Router.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/29/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit
import Alamofire

enum Router: URLRequestConvertible {
    
    // configurations
    
    static let baseURLString  = API.Base
    static let resultsPerPage = 15
    
    static let format   = "json"// "xml"
    static let language = "en"// "ar"
    static let country  = "ea"// "sa"
    
    // Auth & Registration
    
    // TODO ...
    
    // Products
    
    case getProductTypes(offset: Int)
    case getProducts
    
    /**********************************
     **  (1)  URLRequestConvertible  **
     **********************************/
    
    var URLRequest: NSMutableURLRequest {
        let result: (path: String, parameters: [String: AnyObject]?) = {
            
            var path: String = ""
            var parameters: [String: AnyObject]?
            
            switch self {
                
            /**********************
            A. Auth & Registration
            **********************/
            
            // TODO ...
                
            /***********
            B. Products
            ************/
                
            case .getProductTypes(let offset):
                path = "products/types"
                parameters = [
                    "page"      : offset,
                    "show"      : Router.resultsPerPage,
                    "language"  : Router.language,
                    "format"    : Router.format
                ]
                
            case .getProducts:
                path = ""
                parameters = [
                    "product_id" : "",
                    "show_offers" : false,
                    "show_attributes" : false,
                    "show_variations" : false,
                    "country" : Router.country,
                    "language" : Router.language,
                    "format" : Router.format,
                    "app_id" : "20455500",
                    "app_secret" : "a3rIAIObv3PSIIKncpEj"
                ]
                
            }
            
            return (path, parameters)
        }()
        
        /***************************
         **  (2)  Request Method  **
         ***************************/
        
        var method: Alamofire.Method {
            switch self {
            case .getProductTypes,
                 .getProducts:
                return .GET
                
                //case .:
                //return .POST
                
                //case .:
                //return .PUT
                
                //case .:
                //return .DELETE
            }
        }
        
        /*****************************
         **  (3)  Request Encoding  **
         *****************************/
        
        var encoding: ParameterEncoding {
            switch self {
            case .getProductTypes,
                 .getProducts:
                return .URL
                
                //case .:
                //return .JSON
            }
        }
        
        /*******************************
         **  (4)  Request Properties  **
         *******************************/
        
        var needsAuthentication: Bool {
            switch self {
            case .getProductTypes,
                 .getProducts:
                return false
                
                //default:
                //return true
            }
        }
        
        let URL = NSURL(string: Router.baseURLString)!
        
        // cache data using NSURLCache
        // TODO this can be implemented in a better way (e.g. using CoreData)
        let cachePolicy: NSURLRequestCachePolicy = Networker.isReachable ? .ReloadIgnoringLocalCacheData : .ReturnCacheDataElseLoad
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(result.path), cachePolicy: cachePolicy, timeoutInterval: 30)
        // override the cache policy in the server's response header
        // @ref http://stackoverflow.com/questions/27785693/alamofire-nsurlcache-is-not-working
        URLRequest.addValue("private", forHTTPHeaderField: "Cache-Control")
        
        URLRequest.HTTPMethod = method.rawValue
        
        //if let token = Router.userToken where needsAuthentication {
        //URLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        //}
        
        return encoding.encode(URLRequest, parameters: result.parameters).0
    }
    
}
