//
//  ViewController.swift
//  GoogleSearchApp
//
//  Created by Yura on 10/30/18.
//  Copyright © 2018 Yuriy Kudreika. All rights reserved.
//

import UIKit

extension UIColor {
    static var mainGray = UIColor(red: 198/255, green: 198/255, blue: 203/255, alpha: 1)
}

class ViewController: UIViewController, UITableViewDataSource {

    // MARK: - Properties
    
    var linksArray: [String] = []
    let api = SearchAPI()
    
    var isLoading = false
    
    // MARK: - Items

    static let myFont : UIFont = UIFont.systemFont(ofSize: 14)

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "linkIdentifier")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.cornerRadius = 12
        return table
    }()
    
    private let googleSearchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Google Search", for: .normal)
        button.titleLabel?.font = myFont
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(googleSearchButtonAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - viewDidLoad()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainGray
        tableView.dataSource = self
        lauoutSetup()
    }
    
    // MARK: - Layout setup
    
    private func lauoutSetup() {
        
        view.addSubview(searchBar)
        view.addSubview(googleSearchButton)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
            ]
        )
        NSLayoutConstraint.activate([
            googleSearchButton.topAnchor.constraint(equalTo: searchBar.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            googleSearchButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            googleSearchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            googleSearchButton.heightAnchor.constraint(equalToConstant: 50)
            ]
        )
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: googleSearchButton.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
            ]
        )
    }

    // MARK: - Actions

    @objc private func googleSearchButtonAction(sender: UIButton) {        
        if !isLoading {
            isLoading = true
            refreshButtonWith(color: .red, title: "Stop")
            call()
        } else {
            refreshButtonWith(color: .green, title: "Google Search")
            api.operationCancel()
            isLoading = false
        }
    }

    // MARK: - Help methods

    func call() {
        if let string = searchBar.text {
            if !string.isEmpty {
                api.operationStartWith(searchText: string) { (returnLinksArray) in
                    
                    if let array = returnLinksArray {
                        self.linksArray = array
                        self.isLoading = false
                        self.refreshButtonWith(color: .green, title: "Google Search") {
                            self.tableView.reloadData()
                        }
                    } else {
                        self.linksArray = []
                        self.refreshButtonWith(color: .green, title: "Google Search") {
                            self.createAlert()
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                createAlert()
                refreshButtonWith(color: .green, title: "Google Search")
                isLoading = false
            }
        }
    }
    
    private func refreshButtonWith(color: UIColor, title: String, action:  (( )-> Void)? = nil) {
        DispatchQueue.main.async {
            action?()
            self.googleSearchButton.setTitle(title, for: .normal)
            self.googleSearchButton.backgroundColor = color
        }
    }
    
    private func createAlert() {
        if let text = searchBar.text {
            if !text.isEmpty {
                let alert = UIAlertController(title: nil, message: "По запросу \(text) ничего не найдено", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(alertAction)
                present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: nil, message: "Введите текст в строку для поиска", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(alertAction)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return linksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "linkIdentifier", for: indexPath)
        cell.textLabel?.text = linksArray[indexPath.row]
        return cell
    }
}

