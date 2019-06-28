//
//  CitiesTableViewController.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 25/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import UIKit

final class CitiesTableViewController: UITableViewController {
    
    private var cities = [City]()

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
        let stringUrl = Constants.baseUrl + "?bbox=" +
            RectOnMap.leftDownCornerCoordinates + "," +
            RectOnMap.rightUpCornerCoordinates + "," + RectOnMap.zoom +
            "&units=metric&appid=" + Constants.appId
        
        NetworkService().fetchData(stringUrl: stringUrl) { [weak self] data in
            
            guard let self = self else { return }
            guard let weatherForCities = WeatherForCities(json: data) else { return }
            
            // to load initial data
            if self.cities.isEmpty {
                self.cities = weatherForCities.cities
                self.tableView.reloadData()
                
            // to reload only updated rows
            } else {
                var indexPathsForReload = [IndexPath]()
                
                for index in self.cities.indices {
                    if self.cities[index].forecast.temp != weatherForCities.cities[index].forecast.temp {
                        indexPathsForReload.append(IndexPath(row: index, section: 0))
                    }
                }
                
                print(indexPathsForReload.count)
                
                if !indexPathsForReload.isEmpty {
                    self.cities = weatherForCities.cities
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
        return Constants.rowHeight
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let cityViewController = CityViewController()
        cityViewController.city = cities[indexPath.row]

        navigationController?.pushViewController(cityViewController, animated: true)
    }
}

extension CitiesTableViewController {
    private struct Constants {
        static let rowHeight: CGFloat = 80
        static let baseUrl = "http://api.openweathermap.org/data/2.5/box/city"
        static let appId = "f7bc46ab2fd400f1b0c787b61e8bf8bc"
    }
    
    private struct RectOnMap {
        static let leftDownCornerCoordinates = "35,54"
        static let rightUpCornerCoordinates = "39,57"
        static let zoom = "8"
    }
}
