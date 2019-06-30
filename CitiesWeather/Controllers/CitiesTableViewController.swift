//
//  CitiesTableViewController.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 25/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import UIKit

final class CitiesTableViewController: UITableViewController {
    
    // MARK: - Model
    private var cities = [City]()
    
    // MARK: - Properties
    private let weatherService = WeatherService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        updateModelFromApi()
    }
    
    private func setupView() {
        setupTableView()
        setupRefreshControll()
    }
    
    private func updateModelFromApi() {
        weatherService.getWeather(from: API.Weather.url) { [weak self] cities in
            guard let self = self else { return }
            
            // to load initial data
            if self.cities.isEmpty {
                self.cities = cities
                self.tableView.reloadData()
                
            // to reload only updated rows
            } else {
                var indexPathsForReload = [IndexPath]()
                
                for index in self.cities.indices {
                    if self.cities[index].forecast.temp != cities[index].forecast.temp {
                        indexPathsForReload.append(IndexPath(row: index, section: 0))
                    }
                }
                
                if !indexPathsForReload.isEmpty {
                    self.cities = cities
                    self.tableView.reloadRows(at: indexPathsForReload, with: .fade)
                }
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .white
        tableView.register(CityCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
        navigationItem.title = "Cities"
    }
    
    private func setupRefreshControll() {
        let refreshControl = UIRefreshControl()
        let title = "Pull to refresh"
        
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)

        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        updateModelFromApi()
    }
}

// MARK: - Table View Data Source

extension CitiesTableViewController {
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CityCell
        cell.city = cities[indexPath.row]
        
        return cell
    }
}

// MARK: - Table View Delegate

extension CitiesTableViewController {
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let cityViewController = CityViewController()
        cityViewController.city = cities[indexPath.row]

        navigationController?.pushViewController(cityViewController, animated: true)
    }
}
