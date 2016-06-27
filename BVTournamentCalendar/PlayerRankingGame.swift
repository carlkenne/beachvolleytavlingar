//
//  PlayerRankingGame.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 20/09/15.
//  Copyright © 2015 Carl Kenne. All rights reserved.
//

import Foundation

struct PlayerRankingDetails {
    var games: [PlayerRankingGame]
    var age: Int
}

struct PlayerRankingGame {
    var period: String
    var periodInt: Int
    var year: String
    var name: String
    var points: Int
    var result: String
    var levelCategory: String
    var isEntryPoint: Bool
}