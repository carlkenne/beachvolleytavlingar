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
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
    

    func removeAll(str: String) -> String{
       return self.stringByReplacingOccurrencesOfString(str, withString: "")
    }
        
    init(htmlEncodedString: String) {
            let encodedData = htmlEncodedString.dataUsingEncoding(NSUnicodeStringEncoding)!
            let attributedOptions = [String: AnyObject]()
            let attributedString = try! NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self.init(attributedString.string)
    }
  

    func replaceOccurancesUTF16(utf16Nbr: Int, with: Character) -> String {
        var chars = Array(self.characters)
        var utf16arr = Array(self.utf16)
        for row in 0 ..< utf16arr.count  {
            if(Int(utf16arr[row]) == utf16Nbr) {
                print(Int(utf16arr[row]))
                chars[row] = with
            }
        }
        return String(chars)
    }
    
    func removeOccurancesUTF16(utf16Nbr: Int) -> String {
        var chars = Array(self.characters)
        var utf16arr = Array(self.utf16)
        for row in 0 ..< utf16arr.count  {
            if(Int(utf16arr[row]) == utf16Nbr) {
                print(Int(utf16arr[row]))
                chars.removeAtIndex(row)
            }
        }
        return String(chars)
    }
}