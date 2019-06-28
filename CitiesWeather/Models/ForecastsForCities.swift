//
//  ForecastsForCities.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 27/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import Foundation

struct ForecastsForCities: Decodable {
    private (set) var cities: [City]
    
    enum CodingKeys: String, CodingKey {
        case cities = "list"
    }
    
    init?(json: Data) {
        do {
            var newValue = try JSONDecoder().decode(ForecastsForCities.self, from: json)
            newValue.cities.reverse()
            self = newValue
        } catch let parsingError {
            print("error", parsingError)
            return nil
        }
        
    }
}
