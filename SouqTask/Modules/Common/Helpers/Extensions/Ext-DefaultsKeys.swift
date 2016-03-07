//
//  Ext-DefaultsKeys.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/4/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

extension DefaultsKeys {
    /// If user passes first app tutorial.
    static let InitialTutorialDone = DefaultsKey<Bool>("initialTutorialDone")
    
    /// User selected product types, chosen in initial setup.
    static let UserProductTypeIds  = DefaultsKey<[String]?>("userProductTypeIds")
}
