//
//  NetworkService.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 27/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import Foundation

final class NetworkService {
    
    func fetchData(url: URL?, completion: @escaping (Data?) -> Void) {
        guard let url = url else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data,
                let response = response,
                ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300 {
                
                DispatchQueue.main.async { completion(data) }
            } else {
                DispatchQueue.main.async { completion(nil) }
            }
            
        }.resume()
    }
}
