//
//  WeatherService.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 30/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import Foundation

final class WeatherService {
    
    private var networkService: NetworkService?
    
    init(networkService: NetworkService = .init()) {
        self.networkService = networkService
    }
    
    func getWeather(from url: URL?, completion: @escaping ([City]?) -> Void) {
        networkService?.fetchData(url: url) { data in
            
            // if somthing wrong
            guard let data = data else {
                completion(nil)
                return
            }
            
            let weather = WeatherForCities(json: data)
            completion(weather?.cities)
        }
    }
}
