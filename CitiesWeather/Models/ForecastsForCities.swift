//
//  ForecastsForCities.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 27/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import Foundation

struct ForecastsForCities: Decodable {
    let cities: [City]
    
    enum CodingKeys: String, CodingKey {
        case cities = "list"
    }
    
    init?(json: Data) {
        do {
            let newValue = try JSONDecoder().decode(ForecastsForCities.self, from: json)
            self = newValue
        } catch let parsingError {
            print("error", parsingError)
            return nil
        }
        
    }
}
