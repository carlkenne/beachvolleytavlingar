//
//  WeatherHelper.swift
//  BVTournamentCalendar
//
//  Created by Wilhelm Fors on 06/03/17.
//  Copyright © 2017 Carl Kenne. All rights reserved.
//

import Foundation

class WeatherHelper {
    
    let arenas = Arenas()
    var time = "2017-03-10T12:00:00Z"
    var temp : Float = 0.0
    var wind : Float = 0.0
    var symbol = 0
    
    func getWeatherFromAPI(urlString: String) {
    
    }
    
    func getWeather(tournament: Tournament) {
        
        let lat = arenas.IKSUSport.lat
        let long = arenas.IKSUSport.long
        
        let dateString = getFormattedDateString(date: tournament.from)
        
        let url = URL(string: "http://opendata-download-metfcst.smhi.se/api/category/pmp2g/version/2/geotype/point/lon/\(long)/lat/\(lat)/data.json")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                if let posts = json["timeSeries"] as? [[String: Any]] {
                    for post in posts {
                        let postTime = post["validTime"] as! String
                        if postTime == dateString {
                            if let parameters = post["parameters"] as? [[String : Any]] {
                                let tempDict = parameters[1] as [String : Any]
                                let tempValue = tempDict["values"] as! [Float]
                                self.temp = tempValue[0]
                                
                                let windDict = parameters[4] as [String : Any]
                                let windValue = windDict["values"] as! [Float]
                                self.wind = windValue[0]
                                
                                print("Vind: \(windValue[0]) m/s")
                                let symbDict = parameters[18] as [String : Any]
                                let symbValue = symbDict["values"] as! [Float]
                                self.symbol = Int(symbValue[0])
                                
                                print("\(tournament.formattedFrom) kl. 12: \(self.getWeatherEmoji(symbolID: self.symbol))\(tempValue[0]) C")
                                print("Vind: \(windValue[0]) m/s")
                            } else {
                                print("Parameters not found")
                            }
                        } else {
                        }
                    }
                } else {
                    print("No timeSeries available")
                }
                
                
            } catch let error as NSError {
                print(error)
            }
        }).resume()
        
    }
    
    func getWeatherEmoji(symbolID : Int) -> String {
        switch symbolID {
        case 1:
            return "☀️"
        case 2:
            return "🌤"
        case 3:
            return "🌤"
        case 4:
            return "⛅️"
        case 5:
            return "🌥"
        case 6, 7:
            return "☁️"
        case 8, 12:
            return "🌧"
        case 9, 13:
            return "⛈"
        case 10, 11, 14, 15:
            return "❄️"
        default:
            return ""
        }
    }
    
    func getFormattedDateString(date: Foundation.Date) -> String {
        print("Entered DateFormatter")
        print("Unformatted date: \(date)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)+"T12:00:00Z"
        
        print("Formatted date: \(dateString)")
        
        return dateString
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
