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
    let formattedFrom: NSString
    let to: NSString
    let period: NSString
    let organiser: NSString
    let name: NSString
    let level: NSString
    let levelCategory: NSString
    let type: NSString
    let link: NSString
    let moreInfo: Bool
}

struct Applicants {
    let players: NSString
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