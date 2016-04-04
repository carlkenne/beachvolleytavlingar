//
//  PointsTableSection.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 17/08/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

struct PointsTableSection {
    let title: String
    let pointsTable: [String]
}

struct PointTable {
    let table: [PointsRank]
    let title: String
}

struct PointsRank {
    let points: Int
    let rank: String
}