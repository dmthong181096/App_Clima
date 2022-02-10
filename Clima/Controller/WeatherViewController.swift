//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManager.delegate =  self
        // Do any additional setup after loading the view.
        searchTextField.delegate = self
    }
}
extension WeatherViewController:  UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        let nameCity = searchTextField.text!
        weatherManager.fetchWeather(nameCity: nameCity)
        print(searchTextField.text!)
//        let string = weatherManager.getConditionName(weatherID: 0)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    //Kiểm khi ng dùng nhậ xong có phải 1 chuỗi k
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        }
        else{
            textField.placeholder = "Nhap TP vào"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
}
extension WeatherViewController: WeatherManagerDelagate{
    //DÙng để hứng dữ liệu từ WeatherManager sang WeatherController
    func didUpdateWeather(_ weatherManager:WeatherManager , weather: WeatherModel)  {
        DispatchQueue.main.async { [self] in
            temperatureLabel.text = weather.temperatureString
            conditionImageView.image = UIImage(systemName: weather.conditionName)
            cityLabel.text = weather.cityName
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
//Phần mở rộng về GPS
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last
        {
            let lat = location.coordinate.latitude
            
            let lon = location.coordinate.longitude
            print(lat)
            print(lon)
            
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
