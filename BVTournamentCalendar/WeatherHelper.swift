//
//  WeatherHelper.swift
//  BVTournamentCalendar
//
//  Created by Wilhelm Fors on 06/03/17.
//  Copyright © 2017 Carl Kenne. All rights reserved.
//

import Foundation

class WeatherHelper {
    
    func getWeather(tournament: Tournament, details: TournamentDetail, onCompletion: @escaping (String) -> Void) {
        let dateString = getFormattedDateString(date: tournament.from)
        
        if details.arena.name == "" {
            onCompletion("Inget väder tillgängligt")
        }
        
        let url = URL(string: "http://opendata-download-metfcst.smhi.se/api/category/pmp2g/version/2/geotype/point/lon/\(details.arena.long)/lat/\(details.arena.lat)/data.json")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let weatherResult = self.parseWeatherJSON(json: json, dateString: dateString)
                DispatchQueue.main.async {
                    onCompletion(weatherResult)
                }
                } catch let error as NSError {
                print(error)
            }
        }).resume()
       
    }
    
    func getWeatherEmoji(symbolID : Int?) -> String {
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)+"T12:00:00Z"
        
        return dateString
    }
    
    func parseWeatherJSON(json: [String:Any], dateString: String) -> String {
        if let posts = json["timeSeries"] as? [[String: Any]] {
            for post in posts {
                let postTime = post["validTime"] as! String
                if postTime == dateString {
                    if let parameters = post["parameters"] as? [[String : Any]] {
                        print("enter loop")
                        let tempDict = parameters[1] as [String : Any]
                        print(tempDict)
                        let tempValue = tempDict["values"] as! [NSNumber]
                        let temp = tempValue[0]
                        
                        let windDict = parameters[4] as [String : Any]
                        print(windDict)
                        let windValue = windDict["values"] as! [NSNumber]
                        let wind = windValue[0]
                        
                        let symbDict = parameters[18] as [String : Any]
                        let symbValue = symbDict["values"] as! [NSNumber]
                        let symbol = Int(exactly: symbValue[0])
                        
                        let resultString = "Väder kl. 12: \(self.getWeatherEmoji(symbolID: symbol))\(temp) ºC, vind: \(wind) m/s"
                        
                        return resultString
                        
                    } else {
                        print("Parameters not found")
                    }
                } else {
                }
            }
        } else {
            print("No timeSeries available")
        }
        return "Inget väder tillgängligt"
    }
    
}

