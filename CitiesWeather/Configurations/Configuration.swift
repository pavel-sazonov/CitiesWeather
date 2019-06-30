//
//  Configuration.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 28/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import Foundation

enum API {
    enum Weather {
        private static let apiKey = "f7bc46ab2fd400f1b0c787b61e8bf8bc"
        private static let baseURL = "http://api.openweathermap.org/data/2.5/box/city"
        private static let rectCoordinates = "35,54,39,57,8"
        
        static var url: URL? {
            let urlString = "\(baseURL)?bbox=\(rectCoordinates)&units=metric&appid=\(apiKey)"
            
            guard let url = URL(string: urlString) else {
                print("bad API URL")
                return nil
            }
            
            return url
        }
    }
    
    enum CityImage {
        private static let apiKey = "12884157-e70aa4ed86563d5ed815564db"
        private static let baseURLString = "https://pixabay.com/api"
        private static let type = "photo"
//        private static let orientation = "vertical"
        private static let category = "places"
        
        static func imageURL(cityName: String) -> URL? {
            let urlString = "\(baseURLString)?key=\(apiKey)&q=\(cityName)&image_type=\(type)&category=\(category)"
            
            guard let url = URL(string: urlString) else {
                print("bad API URL")
                return nil
            }
            
            return url
        }
    }
}
