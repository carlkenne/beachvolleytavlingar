//
//  DownloaderBase.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 20/09/15.
//  Copyright © 2015 Carl Kenne. All rights reserved.
//

import Foundation

class DownloaderBase {
    
    func cleanValue(_ value:AnyObject) -> String {
        
        return (value as! TFHppleElement).content.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            .replacingOccurrences(of: "ZoumlZ", with: "ö")
            .replacingOccurrences(of: "ZOumlZ", with: "Ö")
            .replacingOccurrences(of: "ZaumlZ", with: "ä")
            .replacingOccurrences(of: "ZAumlZ", with: "ä")
            .replacingOccurrences(of: "ZaringZ", with: "å")
            .replacingOccurrences(of: "ZAringZ", with: "Å")
    }
    
    func cleanValue(_ value:Any) -> String {
        
        return (value as! TFHppleElement).content.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            .replacingOccurrences(of: "ZoumlZ", with: "ö")
            .replacingOccurrences(of: "ZOumlZ", with: "Ö")
            .replacingOccurrences(of: "ZaumlZ", with: "ä")
            .replacingOccurrences(of: "ZAumlZ", with: "ä")
            .replacingOccurrences(of: "ZaringZ", with: "å")
            .replacingOccurrences(of: "ZAringZ", with: "Å")
    }
}
