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
    let to: String
    let period: String
    let organiser: String
    let name: String
    let level: String
    let levelCategory: String
    let type: String
    let link: String
    let moreInfo: Bool
}

struct Applicants {
    let players: String
    let club: NSString
    let type: NSString
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
}

struct ApplicantsTableSection {
    let title: String
    let applicants: [Applicants]
}

struct TournamentDetail {
    let link: NSString
    let table: NSString
    let redirectURL: NSString
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