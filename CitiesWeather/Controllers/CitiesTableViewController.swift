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
        
        tableView.register(CityCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
        
        navigationItem.title = "Cities"
        
        view.backgroundColor = .white
        
        updateModelFromApi()
    }
    
    private func updateModelFromApi() {
        let stringUrl = Constants.baseUrl + "?bbox=" +
            RectOnMap.leftDownCornerCoordinates + "," +
            RectOnMap.rightUpCornerCoordinates + "," + RectOnMap.zoom +
            "&units=metric&appid=" + Constants.appId
        
        NetworkService().fetchData(stringUrl: stringUrl) { data in
            let forecasts = ForecastsForCities(json: data)
            self.cities = forecasts?.cities ?? []
            self.cities.sort { $0.name < $1.name }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
