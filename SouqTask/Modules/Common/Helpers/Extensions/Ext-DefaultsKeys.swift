//
//  Ext-DefaultsKeys.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/4/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

extension DefaultsKeys {
    /// Whether initial product types selection was done.
    static let InitialSetupDone   = DefaultsKey<Bool>("initialSetupDone")
    /// User selected product types, chosen in initial setup.
    static let UserProductTypeIds = DefaultsKey<[String]?>("userProductTypeIds")
}
