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
    
    func getBase() -> String {
        if(type.rangeOfString("V55+ D") != nil ) {
            return "Dam 55+"
        }
        if(type.rangeOfString("V50+ D") != nil ) {
            return "Dam 50+"
        }
        if(type.rangeOfString("V45+ D") != nil ) {
            return "Dam 45+"
        }
        if(type.rangeOfString("V40+ D") != nil ) {
            return "Dam 40+"
        }
        if(type.rangeOfString("V35+ D") != nil ) {
            return "Dam 35+"
        }
        if(type.rangeOfString("V55+ H") != nil ) {
            return "Herr 55+"
        }
        if(type.rangeOfString("V50+ H") != nil ) {
            return "Herr 50+"
        }
        if(type.rangeOfString("V45+ H") != nil ) {
            return "Herr 45+"
        }
        if(type.rangeOfString("V40+ H") != nil ) {
            return "Herr 40+"
        }
        if(type.rangeOfString("V35+ H") != nil ) {
            return "Herr 35+"
        }
        if(type.rangeOfString("U18 P") != nil ) {
            return "pojkar ungdom 18"
        }
        if(type.rangeOfString("U16 P") != nil ) {
            return "pojkar ungdom 16"
        }
        if(type.rangeOfString("U18 F") != nil ) {
            return "flickor ungdom 18"
        }
        if(type.rangeOfString("U16 F") != nil ) {
            return "flickor ungdom 16"
        }
        if(type.rangeOfString("Junior D") != nil ) {
            return "Junior Dam"
        }
        if(type.rangeOfString("Junior H") != nil ) {
            return "Junior Herr"
        }
        if(type.rangeOfString("BlåGrön") != nil ) {
            return type
        }
        if(type.rangeOfString("RödSvart") != nil ) {
            return type
        }
        if(type.rangeOfString("H") != nil ) {
            return "Herr"
        }
        if(type.rangeOfString("D") != nil ) {
            return "Dam"
        }
        if(type.rangeOfString("M") != nil ) {
            return "Mixed"
        }
        return ""
    }
    
    func getTypeName() -> String {
        var name = getBase();
        if(type.rangeOfString("DV") != nil || type.rangeOfString("HV") != nil || type.rangeOfString("MV") != nil || type.rangeOfString("PV") != nil || type.rangeOfString("FV") != nil) {
            return name + " Väntelista"
        }
        if(type.rangeOfString("DÖ") != nil || type.rangeOfString("HÖ") != nil || type.rangeOfString("MÖ") != nil || type.rangeOfString("PÖ") != nil || type.rangeOfString("FÖ") != nil) {
            return name + " partner önskas"
        }
        
        return name
    }
}

struct ApplicantsTableSection {
    let isSlider: Bool
    let title: String
    let applicants: [Applicants]
}
