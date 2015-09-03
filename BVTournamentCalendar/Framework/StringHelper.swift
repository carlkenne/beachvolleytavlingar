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
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
    

    func removeAll(str: String) -> String{
       return self.stringByReplacingOccurrencesOfString(str, withString: "")
    }
        
    init(htmlEncodedString: String) {
            var encodedData = htmlEncodedString.dataUsingEncoding(NSUnicodeStringEncoding)!
            let attributedOptions = [String: AnyObject]()
            let attributedString = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil)!
            self.init(attributedString.string)
    }
  

    func replaceOccurancesUTF16(utf16Nbr: Int, with: Character) -> String {
        var chars = Array(self)
        var utf16arr = Array(self.utf16)
        for var row = 0; row < utf16arr.count ; row++ {
            if(Int(utf16arr[row]) == utf16Nbr) {
                println(Int(utf16arr[row]))
                chars[row] = with
            }
        }
        var str = String()
        str.extend(chars)
        return str
    }
    
    func removeOccurancesUTF16(utf16Nbr: Int) -> String {
        var chars = Array(self)
        var utf16arr = Array(self.utf16)
        for var row = 0; row < utf16arr.count ; row++ {
            if(Int(utf16arr[row]) == utf16Nbr) {
                println(Int(utf16arr[row]))
                chars.removeAtIndex(row)
            }
        }
        var str = String()
        str.extend(chars)
        return str
    }
}