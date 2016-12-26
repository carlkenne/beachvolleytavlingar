//
//  Tournament.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 27/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

struct Tournament {
    let from: Foundation.Date
    let formattedFrom: String
    let to: Foundation.Date
    let period: String
    let organiser: String
    let name: String
    let level: String
    let levelCategory: String
    let type: String
    let link: String //link to the tournament detail page
    let moreInfo: Bool
}

struct PeriodTableSection {
    let title: String
    let tournaments: [Tournament]
}

