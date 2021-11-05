//
//  Whether Manager.swift
//  Clima
//
//  Created by Visakh D on 28/10/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func updateWeather(weather:WeatherModel)
}

struct WeatherManager {
    let whetherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=d5d12596e43c663d81581d6ea4447ffb&units=metric"
   
    
    var weatherDelegate : WeatherManagerDelegate?
    
    func fetchWhether(cityName:String)  {
        let urlString = "\(whetherUrl)&q=\(cityName)"
        request(urlStr: urlString)
        print(urlString)
    }
    
    func fetchWhether(latitude : CLLocationDegrees ,longitude : CLLocationDegrees) {

        let urlString = "\(whetherUrl)&lat=\(latitude)&lon=\(longitude)"
        request(urlStr: urlString)
        print(urlString)
    }
    
    func request (urlStr: String) {
        if let url = URL(string: urlStr) {
            
            let session = URLSession(configuration: .default )
            
            let task = session.dataTask(with: url) { (data, responds, error )in
                if  error != nil {
                    print(error!)
                }
                if let getData = data {
                    if let weather = self.parseJSON(weatherData: getData) {
                        weatherDelegate?.updateWeather(weather: weather)
                    }
                }
            }
            task.resume()
        }
        
        
    }
    
    func parseJSON(weatherData: Data)-> WeatherModel? {
        
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id =  decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            print(decodedData)
            let weather = WeatherModel(conditionId: id, cityName: name, temperature:temp)
            return weather
        }catch {
            print(error)
            return nil
        }
    }
    
    
}
