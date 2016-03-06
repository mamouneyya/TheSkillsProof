//
//  Ext-NSDate.swift
//  SouqTask
//
//  Created by Ma'moun Diraneyya on 3/6/16.
//  Copyright © 2016 Mamouneyya. All rights reserved.
//

import UIKit

extension NSDate {

    /**
        Returns a user friendly formatted string for this date (e.g. XX minutes ago, etc.).
        
        - Returns: A user friendly formatted string for this date.
    */
    func userFriendlyDateString() -> String {
        var timeStamp = self.timeIntervalSinceNow
        timeStamp = timeStamp * -1
        
        if timeStamp < 1 {
            return "Just now"
            
        } else if timeStamp < 60 {
            return "Less than minute ago";
            
        } else if timeStamp < 60 * 60 {
            let diff = Int(round(timeStamp / 60))
            
            if diff == 1 {
                return ("Minute ago")
            } else {
                return ("\(diff) minutes ago")
            }
            
        } else if timeStamp < 60 * 60 * 24 {
            let diff = Int(round(timeStamp / 60 / 60))
            
            if diff == 1 {
                return ("Hour ago")
            } else {
                return ("\(diff) hours ago")
            }
            
        } else if timeStamp < 60 * 60 * 24 * 30 {
            let diff = Int(round(timeStamp / 24 / 60 / 60))
            
            if diff == 1 {
                return ("Day ago")
            } else {
                return ("\(diff) days ago")
            }
            
        } else if timeStamp < 60 * 60 * 24 * 30 * 12 {
            let diff = Int(round(timeStamp / 30 / 24 / 60 / 60))
            
            if diff == 1 {
                return ("Month ago")
            } else {
                return ("\(diff) months ago")
            }
            
        } else {
            return "More than a year ago"
        }
    }

}
