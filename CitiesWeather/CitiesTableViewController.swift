//
//  CitiesTableViewController.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 25/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import UIKit

class CitiesTableViewController: UITableViewController {
    
    var cities = [City]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
        
        navigationItem.title = "Cities"
        
        view.backgroundColor = .white
        
        // test cities
        cities += [
            City(name: "Moscow", temp: 25),
            City(name: "Samara", temp: 30),
            City(name: "Sochi", temp: 32)
        ]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        cell.textLabel?.text = cities[indexPath.row].name
        
        return cell
    }
}

// MARK: - Table View Delegate

extension CitiesTableViewController {
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
