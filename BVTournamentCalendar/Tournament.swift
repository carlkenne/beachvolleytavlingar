//
//  Tournament.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 27/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

struct Tournament {
    let from: NSDate
    let formattedFrom: String
    let to: NSDate
    let period: String
    let organiser: String
    let name: String
    let level: String
    let levelCategory: String
    let type: String
    let link: String //link to the tournament detail page
    let moreInfo: Bool
    
    func getTypeName() -> String {
        if(type == "H" ) {
            return "Herr"
        }
        if(type == "HV" ) {
            return "Herr Väntelista"
        }
        if(type == "D" ) {
            return "Dam"
        }
        if(type == "DV" ) {
            return "Dam Väntelista"
        }
        if(type == "M" ) {
            return "Mixed"
        }
        if(type == "MV" ) {
            return "Mixed Väntelista"
        }
        return ""
    }
}

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
            return (rankingPoints as String).toInt()!
        }
        return (entryPoints as String).toInt()!
    }
    
    func getTypeName() -> String {
        if(type == "H" ) {
            return "Herr"
        }
        if(type == "HV" ) {
            return "Herr Väntelista"
        }
        if(type == "D" ) {
            return "Dam"
        }
        if(type == "DV" ) {
            return "Dam Väntelista"
        }
        if(type == "M" ) {
            return "Mixed"
        }
        if(type == "MV" ) {
            return "Mixed Väntelista"
        }
        return ""
    }
}

struct PlayerRanking {
    var rankByPoints: Int
    var rankByEntryPoints: Int
    var name: String
    var club: String
    var points: Int
    var entryPoints: Int
}

struct ApplicantsTableSection {
    let isSlider: Bool
    let title: String
    let applicants: [Applicants]
}

struct TournamentDetail{
    let link: NSString //link to the tournament detail page should always be the same as tournament.link
    let table: NSString
    let setServerSessionCookieUrl: NSString //this must be requested first to set the server session cookie
    let fromHour: String
    let toHour: String
    let maxNoOfParticipants: Int
}

struct PeriodTableSection {
    let title: String
    let tournaments: [Tournament]
}

struct FilterSettings{
    var black: Bool = true
    var green: Bool = true
    var challenger: Bool = true
    var mixed: Bool = true
    var misc: Bool = true
}