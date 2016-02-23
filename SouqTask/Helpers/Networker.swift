//
//  Networker.swift
//  Open Souq Assignment
//
//  Created by Ma'moun Diraneyya on 11/4/15.
//  Copyright © 2015 Mamouneyya. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

//enum Router: URLRequestConvertible {
    
    //static let baseURLString = API.Base
    //static let resultsPerPage = 50
    
    //// Apps
    
    //case getApplications
    
    //// MARK: URLRequestConvertible
    
    //var URLRequest: NSMutableURLRequest {
        //let result: (path: String, parameters: [String: AnyObject]?) = {
            //return ("topfreeapplications/limit=\(Router.resultsPerPage)/json", nil)
        //}()

        //let URL = NSURL(string: Router.baseURLString)!
        //// cache data using NSURLCache
        //// TODO this can be implemented in a better way (e.g. using CoreData)
        //let cachePolicy: NSURLRequestCachePolicy = Networker.isReachabile() ? .ReloadIgnoringLocalCacheData : .ReturnCacheDataElseLoad
        //let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(result.path), cachePolicy: cachePolicy, timeoutInterval: 30)
        //// override the cache policy in the server's response header
        //// @ref http://stackoverflow.com/questions/27785693/alamofire-nsurlcache-is-not-working
        //URLRequest.addValue("private", forHTTPHeaderField: "Cache-Control")
        
        //let encoding = Alamofire.ParameterEncoding.URL

        //return encoding.encode(URLRequest, parameters: result.parameters).0
    //}
    
//}

class Networker: Alamofire.Manager {

    static let sharedManager = Networker()
    static let sharedImageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .LIFO,
        maximumActiveDownloads: 4,
        imageCache: AutoPurgingImageCache()
    )

    // MARK: - Helpers
    
    //class func isReachabile() -> Bool {
        //let reachability: Reachability
        
        //do {
            //reachability = try Reachability.reachabilityForInternetConnection()
        //} catch {
            //print("Unable to create Reachability")
            //return false
        //}
        
        //return reachability.isReachable()
    //}
    
    // MARK: - Request Methods

    class func request(URLRequest: URLRequestConvertible) -> Request {
        return Networker.sharedManager.request(URLRequest)
    }
    
    class func request(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .JSON,
        headers: [String: String]? = nil)
        -> Request
    {
        return Networker.sharedManager.request(
            method,
            URLString,
            parameters: parameters,
            encoding: encoding,
            headers: headers
            )
    }
    
    class func downloadImage(
        URLRequest URLRequest: URLRequestConvertible,
        filter: ImageFilter? = nil,
        completion: ImageDownloader.CompletionHandler?)
        -> RequestReceipt?
    {
        return Networker.sharedImageDownloader.downloadImage(
            URLRequest: URLRequest,
            filter: filter,
            completion: completion)
    }
    
}
