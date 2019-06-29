//
//  CityViewController.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 26/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import UIKit

final class CityViewController: UIViewController {
    
    // MARK: - Model
    var city: City?
    
    // MARK: - Views
    private weak var spinner: UIActivityIndicatorView!
    private weak var cityImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = city?.name
        
        setupSpinner()
        updateModelFromApi()
    }
    
    private func setupSpinner() {
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.color = .gray
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        self.spinner = spinner
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupView() {
        
        let cityImageView = UIImageView()
        cityImageView.translatesAutoresizingMaskIntoConstraints = false
        cityImageView.image = cityImage
        view.addSubview(cityImageView)
        
        let blackView = UIView()
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        blackView.isOpaque = false
        blackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blackView)
        
        let tempLabel = UILabel()
        if let temp = city?.forecast.temp { tempLabel.text = String(Int(temp.rounded())) + "°" }
        tempLabel.font = UIFont.systemFont(ofSize: 100)
        tempLabel.textColor = .white
        tempLabel.textAlignment = .center
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tempLabel)
        
        NSLayoutConstraint.activate([
            cityImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cityImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            cityImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cityImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            blackView.leadingAnchor.constraint(equalTo: cityImageView.leadingAnchor),
            blackView.trailingAnchor.constraint(equalTo: cityImageView.trailingAnchor),
            blackView.topAnchor.constraint(equalTo: cityImageView.topAnchor),
            blackView.bottomAnchor.constraint(equalTo: cityImageView.bottomAnchor),
            tempLabel.leadingAnchor.constraint(equalTo: cityImageView.leadingAnchor),
            tempLabel.trailingAnchor.constraint(equalTo: cityImageView.trailingAnchor),
            tempLabel.topAnchor.constraint(equalTo: cityImageView.topAnchor, constant: 100)
            
            ])
    }
    
    private func updateModelFromApi() {
        let networkService = NetworkService()
        guard let cityName = city?.name else { return }
        
        networkService.fetchData(url: API.CityImage.imageURL(cityName: cityName)) { [weak self] data in
            guard let self = self else { return }
            
            let cityImages = CityImagesResponse(json: data)
            
            guard let imageStringUrl = cityImages?.cities.first?.imageUrl else {
                let image = UIImage(named: "default")
                self.cityImage = image
                self.setupView()
                self.spinner.stopAnimating()
                return
            }
            
            guard let imageUrl = URL(string: imageStringUrl) else { return }
            
            networkService.fetchData(url: imageUrl) { data in
                let image = UIImage(data: data)
                self.cityImage = image
                self.spinner.stopAnimating()
                self.setupView()
            }
        }
    }
}
