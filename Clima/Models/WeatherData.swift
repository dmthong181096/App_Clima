//
//  WeatherData.swift
//  Clima
//
//  Created by Thông Đoàn on 10/08/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
//biển đổi dữ liệu từ api về dữ liệu có thể dùng(4)
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    
}
struct Main:Codable {
    let temp: Double
}
struct Weather: Codable{
    let id: Int
    let description: String
    
    let main: String

    let icon:String
}



