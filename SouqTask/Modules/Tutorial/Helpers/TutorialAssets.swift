//
//  TutorialAssets.swift
//  SouqTask
//
//  Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

// MARK: - Asset Catalogs
// Automatically generated by swiftrsrc. Do not edit.

extension UIImage {
    enum TutorialAsset: String {
        case Tutorial_1 = "tutorial-1"
        case Tutorial_2 = "tutorial-2"
        
        var image: UIImage {
            return UIImage(asset: self)
        }
    }

    convenience init!(asset: TutorialAsset) {
        self.init(named: asset.rawValue)
    }
}
