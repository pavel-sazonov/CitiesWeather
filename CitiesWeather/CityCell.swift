//
//  CityCell.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 25/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import UIKit

final class CityCell: UITableViewCell {
    
    // MARK: - Constants
    private let padding: CGFloat = 8
    private let spacing: CGFloat = 16
    
    var city: City? {
        didSet {
            if let city = city {
                cityNameLabel.text = city.name
                tempLabel.text = String(Int(city.forecast.temp.rounded())) + "°"
            }
        }
    }
    
    private weak var cityNameLabel: UILabel!
    private weak var tempLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    private func setupView() {
        let cityNameLabel = UILabel()
        cityNameLabel.font = UIFont.systemFont(ofSize: 20)
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cityNameLabel)
        self.cityNameLabel = cityNameLabel
        
        let tempLabel = UILabel()
        tempLabel.text = "--"
        tempLabel.font = UIFont.systemFont(ofSize: 26)
        tempLabel.textColor = .blue
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tempLabel)
        self.tempLabel = tempLabel
        
        NSLayoutConstraint.activate([
            cityNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            cityNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            tempLabel.leadingAnchor.constraint(greaterThanOrEqualTo: cityNameLabel.trailingAnchor, constant: spacing),
            tempLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
    }
}
