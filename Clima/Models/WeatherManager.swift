//
//  WeatherManager.swift
//  Clima
//
//  Created by Thông Đoàn on 09/08/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelagate {
    func didUpdateWeather(_ weatherManager:WeatherManager , weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?"
    let apiKey = "8e65bfbcc0ec26429a47356e968fe507"
    
    
    var delegate : WeatherManagerDelagate?
    func fetchWeather(nameCity:String) {
        var urlString = "\(weatherURL)&q=\(nameCity)&appid=\(apiKey)"
//        print(urlString)
        performRequest(with:urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees , longitude: CLLocationDegrees) {
        var urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
//        print(urlString)
        performRequest(with:urlString)
    }
    
    
    //yêu cầu trả dữ liệu từ api về app
    func performRequest(with urlString:String) {
        //1. Create a URL
        if let url = URL(string: urlString){
            //2. Create a URLsession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            //Trả về dữ liệu
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8)
                    let weather = parseJSON(safeData)
//                    print(dataString)
//                    let weatherVC = WeatherViewController()
                    self.delegate?.didUpdateWeather(self ,weather: weather!)
                    
                }
            }
            //4. Start a task
                task.resume()
        }
    }
    //biển đổi dữ liệu từ api về dữ liệu có thể dùng(4)
    func parseJSON(_ weatherData: Data) ->WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decoData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decoData.weather[0].description) //in ra tên thành phố từ api
            let id = decoData.weather[0].id
            let name = decoData.name
            let temp = decoData.main.temp
            
            //Tạo WeatherModel để chứa weather mới để sử dụng trong app, còn WeatherData là để nhận dl từ api
            let weatherModel = WeatherModel(conditionID: id, cityName: name, temperature: temp)
//            print(weatherModel.conditionName)
//            print(weatherModel.temperatureString)
            return weatherModel
            
        } catch  {
            print(error)
            return nil
        }
    }

}
