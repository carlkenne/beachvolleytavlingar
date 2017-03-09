//
//  Arenas.swift
//  BVTournamentCalendar
//
//  Created by Wilhelm Fors on 09/03/17.
//  Copyright © 2017 Carl Kenne. All rights reserved.
//

import Foundation

struct Arenas {
    let BeachCenter = Arena(lat: 57.73790633089288, long: 12.037104964256287, name: "Beach Center")
    let IKSUSport = Arena(lat: 63.818677134927896, long: 20.318371653556824, name: "IKSU Sport")
    let BeachHallen = Arena(lat: 59.17969799999999, long: 17.653684, name: "The Beach, Södertälje")
    let ActiveBeach = Arena(lat: 56.01973839999999, long: 12.730825099999947, name: "Active Beach, Helsingborg")
}

struct Arena {
    let lat: Float
    let long: Float
    let name: String
}
