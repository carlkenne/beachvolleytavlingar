//
//  TournamentLocationFinder.swift
//  BVTournamentCalendar
//
//  Created by Wilhelm Fors on 09/03/17.
//  Copyright © 2017 Carl Kenne. All rights reserved.
//

import Foundation

class TournamentLocationFinder {
    
    let arenas : [Arena]
    
    func getArena(name: String, organiser: String) -> Arena{
        
        if name == "" && organiser == ""{
            return Arena(lat: 0, long: 0, name: "", organiser: "")
        }
        
        for arena in arenas {
            if name.lowercased() == arena.name.lowercased() {
                return arena
            }
        }
        
        for arena in arenas {
            if organiser.lowercased() == arena.organiser.lowercased() {
                return arena
            }
        }
        return Arena(lat: 0, long: 0, name: "", organiser: "")
    }
    
    init() {
        arenas = [BeachCenter, IKSUSport, BeachHallen, ActiveBeach, Skatås, SkreaStrand, Tylösand, FriaBad, Mellbystrand, VästraHamnen, GamlaIP, Ribban, Borgarparken, Svedala, Åhus, Karlskrona, Långviken, Böda, Kärsön, Mälarbadet, Betnessand, Luleå, Habo, Växjö, Örebro, Fyrishov, Farstanäs, Karlstad, ToftaStrand, Linköping, Jönköping, Mariestad]
    }

    
    let BeachCenter = Arena(lat: 57.73790633089288, long: 12.037104964256287, name: "Beach Center", organiser: "Göteborg Beachvolley Club")
    let IKSUSport = Arena(lat: 63.818677134927896, long: 20.318371653556824, name: "Las Palmas, IKSU Sport", organiser: "")
    let BeachHallen = Arena(lat: 59.17969799999999, long: 17.653684, name: "The Beach, Södertälje", organiser: "08 Beachvolley Club")
    let ActiveBeach = Arena(lat: 56.01973839999999, long: 12.730825099999947, name: "Active Beach, Helsingborg", organiser:"")
    let Skatås = Arena(lat: 57.703009, long: 12.041488, name: "Skatås, Göteborg", organiser: "Morgondagens Beachvolleyboll Club")
    let SkreaStrand = Arena(lat: 56.883220, long: 12.504753, name: "Skrea Strand", organiser: "Falkenbergs Volleybollklubb")
    let Tylösand = Arena(lat: 56.654286, long: 12.730966, name: "SummerSmash Arena Tylösand", organiser:"")
    let FriaBad = Arena(lat: 56.058163, long: 12.6812, name: "Fria Bad, Helsingborg", organiser: "IFK Helsingborg")
    let Mellbystrand = Arena(lat: 56.513852, long: 12.942538, name: "Mellbystrand", organiser: "")
    let VästraHamnen = Arena(lat: 55.618979, long: 12.977192, name: "Scaniaparken, Västra Hamnen", organiser: "Malmö Beachvolley Club")
    let GamlaIP = Arena(lat: 55.594131, long: 12.995839, name: "Gamla IP", organiser: "")
    let Ribban = Arena(lat: 55.601259, long: 12.962837, name: "Ribban, Malmö", organiser: "")
    let Borgarparken = Arena(lat: 55.723130, long: 13.208835, name: "Borgarparkens Beach Arena", organiser: "Lunds Volleybollklubb")
    let Svedala = Arena(lat: 55.522178, long: 13.218312, name: "Svedala Beachcourt (Roslätt)", organiser: "Svedala Volleybollklubb")
    let Åhus = Arena(lat: 55.932465, long: 14.321108, name: "Åhus", organiser: "")
    let Karlskrona = Arena(lat: 56.181136, long: 15.583034, name: "Långö", organiser: "KFUM Gymnastik & IA Karlskrona")
    let Långviken = Arena(lat: 56.652, long: 16.336986, name: "Långviken", organiser: "")
    let Böda = Arena(lat: 57.260031, long: 17.054064, name: "Bödagården, Öland", organiser: "Föreningen Beachvolley-Aid")
    let Kärsön = Arena(lat: 59.323226, long: 17.914560, name: "Kärsögårdens beachbanor", organiser: "Bromma KFUK-KFUM")
    let Mälarbadet = Arena(lat: 59.222267, long: 17.613970, name: "Mälarbadet", organiser: "Södertelge Volleybollklubb")
    let Betnessand = Arena(lat: 63.662778, long: 20.092878, name: "Bettnessand", organiser: "Idrottsklubben Studenterna i Umeå")
    let Luleå = Arena(lat: 65.587500, long: 22.124770, name: "Gültzauudden", organiser: "Lule Volley")
    let Habo = Arena(lat: 57.913243, long: 14.093179, name: "Habo Energi Beach Arena", organiser: "Habo Wolleyklubb 87")
    let Växjö = Arena(lat: 56.870509, long: 14.816372, name: "Kampen", organiser: "Växjö Volleybollklubb")
    let Örebro = Arena(lat: 59.278157, long: 15.254796, name: "Alnängsbadet, Oljevägen 10, Örebro", organiser: "Beachbrothers Beachvolley Club")
    let Fyrishov = Arena(lat: 59.870607, long: 17.618959, name: "Fyrisbeach Arena, Uppsala", organiser: "Fyrishov Beachvolley Club")
    let Farstanäs = Arena(lat: 59.097176, long: 17.653806, name: "Farstanäs Havsbad", organiser: "")
    let Karlstad = Arena(lat: 59.391344, long: 13.510603, name: "Sundsta Beachvolleyplaner", organiser: "Karlstads Volleybollklubb")
    let ToftaStrand = Arena(lat: 57.486657, long: 18.128917, name: "Tofta strand Gotland", organiser: "Team Gotland Volleybollklubb")
    let Linköping = Arena(lat: 58.422578, long: 15.669036, name: "Linköping Beach Arena", organiser: "Linköping Beach Arena Club")
    let Jönköping = Arena(lat: 57.7828, long: 14.209646, name: "Vätterstranden, Jönköping", organiser: "Jönköpings Beachvolleyclub")
    let Mariestad = Arena(lat: 58.714712, long: 13.820994, name: "Hamnen, Mariestad", organiser: "Mariestads Volleybollklubb")
    
    
}

struct Arena {
    let lat: Float
    let long: Float
    let name: String
    let organiser: String
}

