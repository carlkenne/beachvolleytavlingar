//
//  StringHelper.swift
//  SandSports
//
//  Created by Carl Kenne on 27/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substring(with: index(startIndex, offsetBy: r.lowerBound) ..< index(startIndex, offsetBy: r.upperBound))
    }
    

    func removeAll(_ str: String) -> String{
       return self.replacingOccurrences(of: str, with: "")
    }
    
    func getStringBetween(_ start: String, end: String, startAt: String?="") -> String{
        //print("getStringBetween: '\(start)' '\(end)' ")
        let theStartIndex = self.range(of: startAt!)
        var theString = self;
        if(theStartIndex != nil) {
            theString = self.substring(from: (theStartIndex?.upperBound)!)
        }
        
        let startIndex = theString.range(of: start)
        if(startIndex == nil) {
            return ""
        }
        //print("start: \(startIndex)")
        let theRest = theString.substring(from: (startIndex?.upperBound)!)
        //print("theRest: \(theRest)")
        let stopIndex = theRest.range(of: end)
        if(stopIndex == nil) {
            return ""
        }
        //print("stop: \((stop?.startIndex)!)")
        let result = theRest.substring(to: (stopIndex?.lowerBound)!).trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines
        );
        
        return result
    }
    
    func getStringAfter(_ start: String, startAt: String?="") -> String{
        //print("getStringBetween: '\(start)' '\(end)' ")
        let theStartIndex = self.range(of: startAt!)
        var theString = self;
        if(theStartIndex != nil) {
            theString = self.substring(from: (theStartIndex?.upperBound)!)
        }
        
        let startIndex = theString.range(of: start)
        if(startIndex == nil) {
            return ""
        }
        //print("start: \(startIndex)")
        return theString.substring(from: (startIndex?.upperBound)!)
    }

    func replaceOccurancesUTF16(_ utf16Nbr: Int, with: Character) -> String {
        var chars = Array(self)
        var utf16arr = Array(self.utf16)
        for row in 0 ..< utf16arr.count  {
            if(Int(utf16arr[row]) == utf16Nbr) {
                print(Int(utf16arr[row]))
                chars[row] = with
            }
        }
        return String(chars)
    }
    
    func removeOccurancesUTF16(_ utf16Nbr: Int) -> String {
        var chars = Array(self)
        var utf16arr = Array(self.utf16)
        for row in 0 ..< utf16arr.count  {
            if(Int(utf16arr[row]) == utf16Nbr) {
                print(Int(utf16arr[row]))
                chars.remove(at: row)
            }
        }
        return String(chars)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringDocumentReadingOptionKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.DocumentReadingOptionKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.DocumentReadingOptionKey(rawValue: key), value)})
}
