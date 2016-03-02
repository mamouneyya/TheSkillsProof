//
//  ProductsRouter.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/2/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit
import Alamofire

extension Product {

    enum Request: RequestConfigurations {
        
        case getProductTypes(offset: Int)
        case getProducts
        
        /***************************
         **  (1)  Request Result  **
         ***************************/
        
        var result: (path: String, parameters: [String: AnyObject]?) {
            var path: String = ""
            var parameters: [String: AnyObject]?
            
            switch self {
            case .getProductTypes(let offset):
                path = "products/types"
                parameters = [
                    "page"      : offset,
                    "show"      : RouterConfigurations.resultsPerPage,
                    "language"  : RouterConfigurations.language,
                    "format"    : RouterConfigurations.format
                ]
                
            case .getProducts:
                path = ""
                parameters = [
                    "product_id"      : "",
                    "show_offers"     : false,
                    "show_attributes" : false,
                    "show_variations" : false,
                    "country"         : RouterConfigurations.country,
                    "language"        : RouterConfigurations.language,
                    "format"          : RouterConfigurations.format
                ]
            }
            
            return (path, parameters)
        }
        
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

    }
    
}