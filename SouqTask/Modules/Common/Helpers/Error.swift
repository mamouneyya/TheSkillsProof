//
//  Error.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/3/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

/// The `Error` struct provides a convenience for creating custom NSErrors.
public struct Error {

    /// The domain used for creating all errors.
    public static let Domain = "com.SouqTask.error"
    
    /// The custom error codes generated by the app.
    public enum Code: Int {
        case SouqRequestFailed = -9000
    
        /// Friendly error message to show to the user for a specified error code.
        public var friendlyMessage: String {
            switch self {
            default:
                return Messages.UnknownError
            }
        }
    }
    
    /**
        Creates an `NSError` with the given error code and failure reason.

        - parameter code:          The error code.
        - parameter failureReason: The failure reason.

        - returns: An `NSError` with the given error code and failure reason.
    */
    public static func errorWithCode(code: Code, failureReason: String) -> NSError {
        return errorWithCode(code.rawValue, failureReason: failureReason)
    }
    
    /**
        Creates an `NSError` with the given error code and failure reason.

        - parameter code:          The error code.
        - parameter failureReason: The failure reason.

        - returns: An `NSError` with the given error code and failure reason.
    */
    public static func errorWithCode(code: Int, failureReason: String) -> NSError {
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        return NSError(domain: Domain, code: code, userInfo: userInfo)
    }

}
