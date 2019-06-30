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
            
            guard let stringImageUrl = CityImagesResponse(json: data)?.cities.first?.imageUrl else {
                // service did not find any images for current city
                completion(nil)
                return
            }
            
            guard let url = URL(string: stringImageUrl) else {
                print("bad image url from api")
                return
            }
            
            self.networkService?.fetchData(url: url) { data in
                completion(UIImage(data: data))
            }
        }
    }
}
