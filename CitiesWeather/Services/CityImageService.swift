//
//  CityImageService.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 30/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import UIKit

final class CityImageService {
    private var networkService: NetworkService?
    
    init(networkService: NetworkService = .init()) {
        self.networkService = networkService
    }
    
    func getImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        networkService?.fetchData(url: url) { data in
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            guard let cityImagesResponse = CityImagesResponse(json: data)  else {
                completion(nil)
                return
            }
            
            // if API did not find any images for current city
            if cityImagesResponse.cities.isEmpty {
                completion(UIImage(named: "default"))
                return
            }
            
            let urlString = cityImagesResponse.cities[0].imageUrl
            
            guard let url = URL(string: urlString) else {
                print("bad image url from api")
                completion(nil)
                return
            }
            
            self.networkService?.fetchData(url: url) { data in
                
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                completion(UIImage(data: data))
            }
        }
    }
}
