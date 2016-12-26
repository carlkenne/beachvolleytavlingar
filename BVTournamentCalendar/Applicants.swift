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
    let club: String
    let type: String
    let time: String
    let rankingPoints: String
    let entryPoints: String
    let status: Bool
    let player1Ranking: String
    let player2Ranking: String
    
    func points() -> Int {
        if(rankingPoints.characters.count > 0) {
            return Int((rankingPoints as String))!
        }
        return Int((entryPoints as String))!
    }
    
    func getBase() -> String {
        if(type.range(of: "V55+ D") != nil ) {
            return "Dam 55+"
        }
        if(type.range(of: "V50+ D") != nil ) {
            return "Dam 50+"
        }
        if(type.range(of: "V45+ D") != nil ) {
            return "Dam 45+"
        }
        if(type.range(of: "V40+ D") != nil ) {
            return "Dam 40+"
        }
        if(type.range(of: "V35+ D") != nil ) {
            return "Dam 35+"
        }
        if(type.range(of: "V55+ H") != nil ) {
            return "Herr 55+"
        }
        if(type.range(of: "V50+ H") != nil ) {
            return "Herr 50+"
        }
        if(type.range(of: "V45+ H") != nil ) {
            return "Herr 45+"
        }
        if(type.range(of: "V40+ H") != nil ) {
            return "Herr 40+"
        }
        if(type.range(of: "V35+ H") != nil ) {
            return "Herr 35+"
        }
        if(type.range(of: "U18 P") != nil ) {
            return "pojkar ungdom 18"
        }
        if(type.range(of: "U16 P") != nil ) {
            return "pojkar ungdom 16"
        }
        if(type.range(of: "U18 F") != nil ) {
            return "flickor ungdom 18"
        }
        if(type.range(of: "U16 F") != nil ) {
            return "flickor ungdom 16"
        }
        if(type.range(of: "Junior D") != nil ) {
            return "Junior Dam"
        }
        if(type.range(of: "Junior H") != nil ) {
            return "Junior Herr"
        }
        if(type.range(of: "BlåGrön") != nil ) {
            return type
        }
        if(type.range(of: "RödSvart") != nil ) {
            return type
        }
        if(type.range(of: "H") != nil ) {
            return "Herr"
        }
        if(type.range(of: "D") != nil ) {
            return "Dam"
        }
        if(type.range(of: "M") != nil ) {
            return "Mixed"
        }
        return ""
    }
    
    func getTypeName() -> String {
        let name = getBase();
        if(type.range(of: "DV") != nil || type.range(of: "HV") != nil || type.range(of: "MV") != nil || type.range(of: "PV") != nil || type.range(of: "FV") != nil) {
            return name + " Väntelista"
        }
        if(type.range(of: "DÖ") != nil || type.range(of: "HÖ") != nil || type.range(of: "MÖ") != nil || type.range(of: "PÖ") != nil || type.range(of: "FÖ") != nil) {
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
