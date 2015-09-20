//
//  Applicants.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 17/08/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

struct Applicants {
    let players: String
    let club: NSString
    let type: String
    let time: NSString
    let rankingPoints: NSString
    let entryPoints: NSString
    let status: Bool
    
    func points() -> Int {
        if(rankingPoints.length>0) {
            return Int((rankingPoints as String))!
        }
        return Int((entryPoints as String))!
    }
    
    func getTypeName() -> String {
        if(type == "H" ) {
            return "Herr"
        }
        if(type == "HV" ) {
            return "Herr Väntelista"
        }
        if(type == "HÖ" ) {
            return "Herr Partner Önskas"
        }
        if(type == "D" ) {
            return "Dam"
        }
        if(type == "DV" ) {
            return "Dam Väntelista"
        }
        if(type == "DÖ" ) {
            return "Dam Partner Önskas"
        }
        if(type == "M" ) {
            return "Mixed"
        }
        if(type == "MV" ) {
            return "Mixed Väntelista"
        }
        if(type == "MÖ" ) {
            return "Mixed Partner Önskas"
        }
        return ""
    }
}

struct ApplicantsTableSection {
    let isSlider: Bool
    let title: String
    let applicants: [Applicants]
}
