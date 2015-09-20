//
//  DownloaderBase.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 20/09/15.
//  Copyright © 2015 Carl Kenne. All rights reserved.
//

import Foundation

class DownloaderBase {
    
    func cleanValue(value:AnyObject) -> String {
        
        return (value as! TFHppleElement).content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            .stringByReplacingOccurrencesOfString("ZoumlZ", withString: "ö")
            .stringByReplacingOccurrencesOfString("ZOumlZ", withString: "Ö")
            .stringByReplacingOccurrencesOfString("ZaumlZ", withString: "ä")
            .stringByReplacingOccurrencesOfString("ZAumlZ", withString: "ä")
            .stringByReplacingOccurrencesOfString("ZaringZ", withString: "å")
            .stringByReplacingOccurrencesOfString("ZAringZ", withString: "Å")
    }
}