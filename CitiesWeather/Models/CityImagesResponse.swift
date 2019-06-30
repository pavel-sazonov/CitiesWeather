//
//  CityImagesRequest.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 29/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import Foundation

struct CityImagesResponse: Decodable {
    let cities: [CityImage]
    
    enum CodingKeys: String, CodingKey {
        case cities = "hits"
    }
    
    init?(json: Data) {        
        do {
            let newValue = try JSONDecoder().decode(CityImagesResponse.self, from: json)
            self = newValue
        } catch let parsingError {
            print("error", parsingError)
            return nil
        }
        
    }
}
