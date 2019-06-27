//
//  City.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 25/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import Foundation

struct City: Decodable {
    let name: String
    let forecast: Forecast
    
    enum CodingKeys: String, CodingKey {
        case name
        case forecast = "main"
    }
}
