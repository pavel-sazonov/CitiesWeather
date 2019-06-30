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
    
    func loadImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
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
            
            guard let imageUrl = URL(string: urlString) else {
                print("bad image url from api")
                completion(nil)
                return
            }
            
            let cache =  URLCache.shared
            let request = URLRequest(url: imageUrl)
            
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                    DispatchQueue.main.async { completion(image) }
                } else {
                    URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        
                        if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                            let cachedData = CachedURLResponse(response: response, data: data)
                            cache.storeCachedResponse(cachedData, for: request)
                            
                            DispatchQueue.main.async { completion(image) }
                        } else {
                            DispatchQueue.main.async { completion(nil) }
                        }
                    }.resume()
                }
            }
        }
    }
}
