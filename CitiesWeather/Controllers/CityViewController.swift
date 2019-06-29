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
        cityImageView.clipsToBounds = true
        cityImageView.contentMode = .scaleAspectFill
        cityImageView.alpha = 0
        view.addSubview(cityImageView)
        
        let dimCityImageView = UIView()
        dimCityImageView.backgroundColor = UIColor.black
        dimCityImageView.alpha = 0
        dimCityImageView.isOpaque = false
        dimCityImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dimCityImageView)
        
        let tempLabel = UILabel()
        if let temp = city?.forecast.temp { tempLabel.text = String(Int(temp.rounded())) + "°" }
        tempLabel.font = UIFont.systemFont(ofSize: 100)
        tempLabel.textColor = .white
        tempLabel.textAlignment = .center
        tempLabel.alpha = 0
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tempLabel)
        
        UIView.animate(withDuration: 0.3) {
            cityImageView.alpha = 1
            dimCityImageView.alpha = 0.5
            tempLabel.alpha = 1
        }
        
        NSLayoutConstraint.activate(
            [
                cityImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                cityImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                cityImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                cityImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                dimCityImageView.leadingAnchor.constraint(equalTo: cityImageView.leadingAnchor),
                dimCityImageView.trailingAnchor.constraint(equalTo: cityImageView.trailingAnchor),
                dimCityImageView.topAnchor.constraint(equalTo: cityImageView.topAnchor),
                dimCityImageView.bottomAnchor.constraint(equalTo: cityImageView.bottomAnchor),
                tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                tempLabel.topAnchor.constraint(equalTo: cityImageView.topAnchor, constant: 100)
            ]
        )
    }
    
    private func updateModelFromApi() {
        let networkService = NetworkService()
        guard let cityName = city?.name else { return }
        
        networkService.fetchData(url: API.CityImage.imageURL(cityName: cityName)) { [weak self] data in
            guard let self = self else { return }
            
            let cityImages = CityImagesResponse(json: data)
            
            guard let imageStringUrl = cityImages?.cities.first?.imageUrl else {
                // if no images for this city on pixabay
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
