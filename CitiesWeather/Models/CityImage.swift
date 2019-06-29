//
//  CityImage.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 29/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import Foundation

struct CityImage: Decodable {
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "largeImageURL"
    }
}
