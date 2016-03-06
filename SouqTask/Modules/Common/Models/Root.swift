//
//  Route.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 2/28/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit
import ObjectMapper

class Root: NSObject, Mappable {
    
    override init() {}
    required init?(_ map: Map) {}
    func mapping(map: Map) {}
    
}