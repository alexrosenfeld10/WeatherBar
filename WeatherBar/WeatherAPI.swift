//
//  WeatherAPI.swift
//  WeatherBar
//
//  Created by Alex Rosenfeld on 12/4/16.
//  Copyright © 2016 Alex Rosenfeld. All rights reserved.
//

import Foundation

struct Weather : CustomStringConvertible{
    var city: String
    var currentTemp: Float
    var conditions: String
    
    var description: String {
        return "\(city): \(currentTemp)F and \(conditions)"
    }
    
    var icon: String
}

class WeatherAPI {
    
    let API_KEY = "7a6391c7aef1aae73682471148915074"
    let BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeather(query: String, success: @escaping (Weather) -> Void) {
        
        let session = URLSession.shared
        // url-escape the query string we're passed
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = NSURL(string: "\(BASE_URL)?APPID=\(API_KEY)&units=imperial&q=\(escapedQuery!)")
        
        let task = session.dataTask(with: url! as URL) { data, response, error in
            // first check for a hard error
            if (error != nil) {
                NSLog("weather api error: \(error)")
            }
            
            // then check the response code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200: // all good!
                    if let weather = self.weatherFromJSONData(data: data! as NSData) {
                        success(weather)
                    }
                case 401: // unauthorized
                    NSLog("weather api returned an 'unauthorized' response. Did you set your API key?")
                default:
                    NSLog("weather api returned response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
        }
        task.resume()
    }
    
    func weatherFromJSONData(data: NSData) -> Weather? {
        typealias JSONDict = [String:AnyObject]
        let json : JSONDict
        
        do {
            json = try JSONSerialization.jsonObject(with: data as Data, options: []) as! JSONDict
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }
        
        var mainDict = json["main"] as! JSONDict
        var weatherList = json["weather"] as! [JSONDict]
        var weatherDict = weatherList[0]
        
        let weather = Weather(
            city: json["name"] as! String,
            currentTemp: mainDict["temp"] as! Float,
            conditions: weatherDict["main"] as! String,
            icon: weatherDict["icon"] as! String
        )
        
        return weather
    }
}
