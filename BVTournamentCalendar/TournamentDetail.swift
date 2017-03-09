//
//  TournamentDetail.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 17/08/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

struct TournamentDetail{
    let arena: String
    let resultatLink: String
    let registrationLink: String
    let link: String //link to the tournament detail page should always be the same as tournament.link
    let table: String
    let setServerSessionCookieUrl: NSString //this must be requested first to set the server session cookie
    let fromHour: String
    let toHour: String
    let maxNoOfParticipants: Int
}
