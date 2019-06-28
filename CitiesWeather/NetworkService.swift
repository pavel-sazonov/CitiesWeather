//
//  NetworkService.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 27/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import Foundation

final class NetworkService {
    
    func fetchData(url: URL?, completion: @escaping (Data) -> Void) {
        guard let url = url else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
}
