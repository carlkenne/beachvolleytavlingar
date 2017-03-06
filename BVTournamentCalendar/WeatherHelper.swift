//
//  WeatherHelper.swift
//  BVTournamentCalendar
//
//  Created by Wilhelm Fors on 06/03/17.
//  Copyright © 2017 Carl Kenne. All rights reserved.
//

import Foundation

class WeatherHelper {
    
    let gbg = Pos(lat: 57.70, long: 11.97)
    
    func getWeatherFromAPI(urlString: String) {
    
    }
    
    func getWeather() {
        print("Entered getWeather")
        let url = URL(string: "http://opendata-download-metfcst.smhi.se/api/category/pmp2g/version/2/geotype/point/lon/11.97/lat/57.7/data.json")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let posts = json["timeSeries"] as? [[String: Any]]
                //print(posts)
                
            } catch let error as NSError {
                print(error)
            }
        }).resume()
    }
    
}

struct Pos {
    var lat : Float
    var long: Float
    init(lat: Float, long : Float) {
        self.lat = lat
        self.long = long
    }
}
