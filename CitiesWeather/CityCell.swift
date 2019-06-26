//
//  CityCell.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 25/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import UIKit

final class CityCell: UITableViewCell {
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.text = "CityNameCityNameCityNameCityNameCityNameCityName"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "38.5"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cityNameLabel)
        addSubview(tempLabel)
        
        NSLayoutConstraint.activate([
            cityNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            cityNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            trailingAnchor.constraint(equalTo: tempLabel.trailingAnchor, constant: 8),
            tempLabel.leadingAnchor.constraint(greaterThanOrEqualTo: cityNameLabel.trailingAnchor, constant: 8),
            tempLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
