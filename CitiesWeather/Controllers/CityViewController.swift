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
    private weak var cityImageView: UIImageView!
    private weak var spinner: UIActivityIndicatorView!
    private weak var tempLabel: UILabel!
    private weak var dimCityImageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = city?.name
        
        setupView()
        updateModelFromApi()
    }
    
    private func setupView() {
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.color = .blue
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        self.spinner = spinner
        
        let cityImageView = UIImageView()
        cityImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cityImageView)
        self.cityImageView = cityImageView
        
        let blackView = UIView()
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        blackView.isOpaque = false
        blackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blackView)
        self.dimCityImageView = blackView
        
        let tempLabel = UILabel()
        if let temp = city?.forecast.temp { tempLabel.text = String(Int(temp.rounded())) + "°" }
        tempLabel.font = UIFont.systemFont(ofSize: 100)
        tempLabel.textColor = .white
        tempLabel.textAlignment = .center
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tempLabel)
        self.tempLabel = tempLabel
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
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
            guard let cityImages = CityImagesResponse(json: data) else { return }
            guard let imageStringUrl = cityImages.cities.first?.imageUrl else { return }
            guard let imageUrl = URL(string: imageStringUrl) else { return }
            
            networkService.fetchData(url: imageUrl) { data in
                if let image = UIImage(data: data) {
                    self.cityImageView.image = image
                }
                self.spinner.stopAnimating()
            }
        }
    }
}
