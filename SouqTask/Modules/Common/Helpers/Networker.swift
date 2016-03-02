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

class Networker {

    // MARK: - Public Vars
    
    /// Singleton's class shared instance
    static let sharedInstance = Networker()

    /// Internet connection reachability
    static var isReachable: Bool {
        if let reachability = Networker.sharedInstance.reachability {
            return reachability.isReachable
        } else {
            print("Unable to create Reachability")
            return false
        }
    }

    // MARK: - Private Vars
    
    /// Internal Alamofire's reachability manager
    private let reachability = NetworkReachabilityManager()
    /// Internal Alamofire's request manager
    private let manager = Alamofire.Manager()
    /// Internal Alamofire's image downloader
    private let imageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .LIFO,
        maximumActiveDownloads: 4,
        imageCache: AutoPurgingImageCache()
    )

    // MARK: - Lifecycle
    
    private init() {
        
    }
    
    // MARK: - Request Methods

    /**
        Creates a request for the specified URL request.
        
        If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
        
        - parameter URLRequest: The URL request
        
        - returns: The created request.
    */
    class func request(URLRequest: URLRequestConvertible) -> Request {
        return Networker.sharedInstance.manager.request(URLRequest)
    }
    
    /**
         Creates a request for the specified request configurations.
         
         If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
         
         - parameter requestConfigurations: The request configurations
         
         - returns: The created request.
     */
    class func request(requestConfigurations: RequestConfigurations) -> Request {
        return Networker.sharedInstance.manager.request(Router(requestConfigurations))
    }
    
    /**
         Creates a request for the specified method, URL string, parameters, parameter encoding and headers.
         
         - parameter method:     The HTTP method.
         - parameter URLString:  The URL string.
         - parameter parameters: The parameters. `nil` by default.
         - parameter encoding:   The parameter encoding. `.URL` by default.
         - parameter headers:    The HTTP headers. `nil` by default.
         
         - returns: The created request.
     */
    class func request(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .JSON,
        headers: [String: String]? = nil)
        -> Request
    {
        return Networker.sharedInstance.manager.request(
            method,
            URLString,
            parameters: parameters,
            encoding: encoding,
            headers: headers
            )
    }
    
    /**
         Creates a download request using the internal `Manager` instance for the specified URL request.
         
         If the same download request is already in the queue or currently being downloaded, the filter and completion
         handler are appended to the already existing request. Once the request completes, all filters and completion
         handlers attached to the request are executed in the order they were added. Additionally, any filters attached
         to the request with the same identifiers are only executed once. The resulting image is then passed into each
         completion handler paired with the filter.
         
         You should not attempt to directly cancel the `request` inside the request receipt since other callers may be
         relying on the completion of that request. Instead, you should call `cancelRequestForRequestReceipt` with the
         returned request receipt to allow the `ImageDownloader` to optimize the cancellation on behalf of all active
         callers.
         
         - parameter URLRequest: The URL request.
         - parameter filter      The image filter to apply to the image after the download is complete. Defaults to `nil`.
         - parameter completion: The closure called when the download request is complete.
         
         - returns: The request receipt for the download request if available. `nil` if the image is stored in the image
         cache and the URL request cache policy allows the cache to be used.
     */
    class func downloadImage(
        URLRequest URLRequest: URLRequestConvertible,
        filter: ImageFilter? = nil,
        completion: ImageDownloader.CompletionHandler?)
        -> RequestReceipt?
    {
        return Networker.sharedInstance.imageDownloader.downloadImage(
            URLRequest: URLRequest,
            filter: filter,
            completion: completion)
    }
    
}
