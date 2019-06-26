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
    private weak var tempLabel: UILabel!
    private weak var dimCityImageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = city?.name
        
        setupView()
    }
    
    private func setupView() {
        let cityImageView = UIImageView()
        guard let url = URL(string: "https://pixabay.com/get/52e2dd4a4c57a414f6da8c7dda79367c1d37dae456566c4870297ad1904dc05db0_1280.jpg")
            else { return }
        guard let imageData = try? Data(contentsOf: url) else { return }
        if let image = UIImage(data: imageData) { cityImageView.image = image }
        
        cityImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cityImageView)
        self.cityImageView = cityImageView
        
        let blackView = UIView()
        blackView.backgroundColor = .black
        blackView.alpha = 0.4
        blackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blackView)
        self.dimCityImageView = blackView
        
        let tempLabel = UILabel()
        if let temp = city?.temp { tempLabel.text = String(Int(temp)) + "°" }
        tempLabel.font = UIFont.systemFont(ofSize: 100)
        tempLabel.textColor = .white
        tempLabel.textAlignment = .center
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tempLabel)
        self.tempLabel = tempLabel
        
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
}
