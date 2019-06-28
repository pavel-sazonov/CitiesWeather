//
//  Configuration.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 28/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import Foundation

enum API {
    private static let apiKey = "f7bc46ab2fd400f1b0c787b61e8bf8bc"
    private static let baseWeatherURLString = "http://api.openweathermap.org/data/2.5/box/city"
    private static let rectCoordinates = "35,54,39,57,8"
    
    static var authenticatedWeatherURL: URL? {
        guard var urlComponents = URLComponents(string: baseWeatherURLString) else { return nil }
        
        urlComponents.query = "bbox=\(rectCoordinates)&units=metric&appid=\(apiKey)"
        
        return urlComponents.url
    }
}
