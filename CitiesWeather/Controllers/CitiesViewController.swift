//
//  CitiesViewController.swift
//  CitiesWeather
//
//  Created by Pavel Sazonov on 25/06/2019.
//  Copyright © 2019 Pavel Sazonov. All rights reserved.
//

import UIKit

final class CitiesViewController: UIViewController {
    
    // MARK: - Model
    private var cities = [City]()
    
    // MARK: - Views
    private weak var tableView: UITableView!
    private weak var refreshControl: UIRefreshControl!
    private weak var messageLabel: UILabel!
    
    
    // MARK: - Properties
    private let weatherService = WeatherService()
    
    override func loadView() {
        super.loadView()
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        self.tableView = tableView
        
        let messageLabel = UILabel()
        messageLabel.isHidden = true
        messageLabel.text = "Something went wrong..."
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        self.messageLabel = messageLabel
        
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Cities"
        
        view.backgroundColor = .white
        
        self.tableView.register(CityCell.self, forCellReuseIdentifier: "cellId")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        setupRefreshControl()
        fetchWeatherData()
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        let title = "Pull to refresh"
        
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        self.refreshControl = refreshControl
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        fetchWeatherData()
    }
    
    private func fetchWeatherData() {
        weatherService.getWeather(from: API.Weather.url) { [weak self] cities in
            guard let self = self else { return }
            
            guard let cities = cities else {
                self.messageLabel.isHidden = false
                return
            }
            
            self.tableView.isHidden = false
            
            // load initial data
            if self.cities.isEmpty {
                self.cities = cities
                self.tableView.reloadData()
                
            // reload only updated rows
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
}

// MARK: - Table View Data Source

extension CitiesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CityCell
        cell.city = cities[indexPath.row]

        return cell
    }
}

// MARK: - Table View Delegate

extension CitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let cityViewController = CityViewController()
        cityViewController.city = cities[indexPath.row]

        navigationController?.pushViewController(cityViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
