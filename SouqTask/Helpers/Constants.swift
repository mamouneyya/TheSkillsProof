//
//  Constants.swift
//  Open Souq Assignment
//
//  Created by Ma'moun Diraneyya on 11/4/15.
//  Copyright © 2015 Mamouneyya. All rights reserved.
//

import UIKit

// MARK: - URLs

struct API {
    static let Base = "https://itunes.apple.com/sa/rss"
}

// MARK: - Colors

struct AppColor {
    static let mainTint = UIColor(red: 45/255, green: 95/255, blue: 145/255, alpha: 1)
}

// MARK: - Fonts

private let familyName = "SFUIText"

enum AppFont: String {
    case Light    = "Light"
    case Regular  = "Regular"
    case SemiBold = "Semibold"
    case Bold     = "Bold"
    
    func Size(size: CGFloat) -> UIFont {
        if let font = UIFont(name: fullFontName, size: size) {
            return font
        }
        
        fatalError("Font '\(fullFontName)' does not exist.")
    }
    
    private var fullFontName: String {
        return rawValue.isEmpty ? familyName : familyName + "-" + rawValue
    }
}

// MARK: - Performance Logging Helpers

var startTime = NSDate()
func TICK(){ startTime =  NSDate() }
func TOCK(function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) {
    print("\(function) Time: \(startTime.timeIntervalSinceNow)\nLine:\(line) File: \(file)")
}
