//
//  Serializer.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/3/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//
//  NOTE The core implementation of these methods are actually taken from AlamofireObjectMapper
//
//  TODO Consider implementing both fuctions using a unified static method..
//

import UIKit

extension Request {

    // MARK: - Response Serializers
    
    public static func ObjectMapperSerializer<T: Mappable>(keyPath: String?, silent: Bool = false) -> ResponseSerializer<T, NSError> {
        return ResponseSerializer { request, response, data, error in
            guard error == nil else {
                if !silent {
                    dispatch_async(dispatch_get_main_queue()) {
                        // TODO needs a more sophisticated error handling
                        Utility.showMessageAlert(.SouqRequestFailed)
                    }
                }
                
                return .Failure(error!)
            }
            
            guard let _ = data else {
                if !silent {
                    dispatch_async(dispatch_get_main_queue()) {
                        // TODO needs a more sophisticated error handling
                        Utility.showMessageAlert(.SouqRequestFailed)
                    }
                }
                
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = Alamofire.Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            // even if the request technically succeed, we still need to check
            // whether the server considers it as valid. So we need to check meta
            // data of the response object, and show any error message to the user
            if !Request.validateResponseErrorsInBody(result.value, silent: silent) {
                let failureReason = "Unkown error."
                let error = Error.errorWithCode(.SouqRequestFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            let JSONToMap: AnyObject?
            if let keyPath = keyPath where keyPath.isEmpty == false {
                JSONToMap = result.value?.valueForKeyPath(keyPath)
            } else {
                JSONToMap = result.value
            }
            
            if let parsedObject = Mapper<T>().map(JSONToMap) {
                return .Success(parsedObject)
            }

            if !silent {
                dispatch_async(dispatch_get_main_queue()) {
                    // TODO needs a more sophisticated error handling
                    Utility.showMessageAlert(.SouqRequestFailed)
                }
            }
            
            let failureReason = "ObjectMapper failed to serialize response."
            let error = Alamofire.Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
            return .Failure(error)
        }
    }
    
    /**
        Adds a handler to be called once the request has finished.

        - parameter keyPath:            The key path where object mapping should be performed
        - parameter completionHandler:  A closure to be executed once the request has finished and the
                                        data has been mapped by ObjectMapper.
        - parameter silent:             If we don't want the serializer to automatically show alerts
                                        for error messages.

        - returns: The request.
     */
    public func responseObject<T: Mappable>(keyPath: String? = "data", silent: Bool = false, completionHandler: Response<T, NSError> -> Void) -> Self {
        return response(queue: nil, responseSerializer: Request.ObjectMapperSerializer(keyPath, silent: silent), completionHandler: completionHandler)
    }
    
    public static func ObjectMapperArraySerializer<T: Mappable>(keyPath: String?, silent: Bool = false) -> ResponseSerializer<[T], NSError> {
        return ResponseSerializer { request, response, data, error in
            guard error == nil else {
                if !silent {
                    dispatch_async(dispatch_get_main_queue()) {
                        // TODO needs a more sophisticated error handling
                        Utility.showMessageAlert(.SouqRequestFailed)
                    }
                }
                
                return .Failure(error!)
            }
            
            guard let _ = data else {
                if !silent {
                    dispatch_async(dispatch_get_main_queue()) {
                        // TODO needs a more sophisticated error handling
                        Utility.showMessageAlert(.SouqRequestFailed)
                    }
                }
                
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = Alamofire.Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)

            // even if the request technically succeed, we still need to check
            // whether the server considers it as valid. So we need to check meta
            // data of the response object, and show any error message to the user
            if !Request.validateResponseErrorsInBody(result.value, silent: silent) {
                let failureReason = "Unkown error."
                let error = Error.errorWithCode(.SouqRequestFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            let JSONToMap: AnyObject?
            if let keyPath = keyPath where keyPath.isEmpty == false {
                JSONToMap = result.value?.valueForKeyPath(keyPath)
            } else {
                JSONToMap = result.value
            }
            
            if let parsedObject = Mapper<T>().mapArray(JSONToMap) {
                return .Success(parsedObject)
            }
            
            if !silent {
                dispatch_async(dispatch_get_main_queue()) {
                    // TODO needs a more sophisticated error handling
                    Utility.showMessageAlert(.SouqRequestFailed)
                }
            }
            
            let failureReason = "ObjectMapper failed to serialize response."
            let error = Alamofire.Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
            return .Failure(error)
        }
    }
    
    /**
        Adds a handler to be called once the request has finished.
         
        - parameter keyPath:            The key path where object mapping should be performed
        - parameter completionHandler:  A closure to be executed once the request has finished and the
                                        data has been mapped by ObjectMapper.
        - parameter silent:             If we don't want the serializer to automatically show alerts
                                        for error messages.
     
        - returns: The request.
    */
    public func responseArray<T: Mappable>(keyPath: String? = "data", silent: Bool = false, completionHandler: Response<[T], NSError> -> Void) -> Self {
        return response(queue: nil, responseSerializer: Request.ObjectMapperArraySerializer(keyPath, silent: silent), completionHandler: completionHandler)
    }
    
    // MARK: - Error Handlers
    
    /**
        Validates errors returned from the server in the response body. This should be called after the response passes request validation (status code is 200 ..< 300, etc.) and returns a valid response data from the server. The function can automatically show alert message with the error message returned to the user.
        
        - parameter responseData:       The returned server Result's value
        - parameter silent:             If we don't want the serializer to automatically show alerts
                                        for error messages.
    
        - returns: Whether server considered the request as successful.
    */
    public static func validateResponseErrorsInBody(responseData: AnyObject!, silent: Bool = false) -> Bool {
        guard (responseData != nil) else { return false }
        
        let metaFields    = responseData.valueForKeyPath("meta")
        let responseField = (metaFields?.valueForKeyPath("response") ?? "") as? String
        let messageField  = (metaFields?.valueForKeyPath("message") ?? "") as? String
        let success       = responseField == "OK"
        
        if let messageField = messageField where !success {
            if !silent {
                dispatch_async(dispatch_get_main_queue()) {
                    Utility.showMessageAlert(messageField)
                }
            }
            
            return false

        } else {
            return true
        }
    }

}
