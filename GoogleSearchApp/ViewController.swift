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

        // FIXME: идентификатор проекта: skilled-tiger-221019
        // FIXME: идентификатор поисковой системы: 005505095743673218968:ploiaiqzo0c
        
        if !isLoading {
            isLoading = true
            googleSearchButton.setTitle("Stop", for: .normal)
            googleSearchButton.backgroundColor = .red
            call()
        } else {
            googleSearchButton.setTitle("Google Search", for: .normal)
            googleSearchButton.backgroundColor = .green
            api.operationCancel()
            isLoading = false
            print("Thread canceled========================================================================")
        }
    }

    // MARK: - Help methods

    func call() {
        if let string = searchBar.text {
            if !string.isEmpty {
                api.operationStartWith(searchText: string) { (returnLinksArray) in
                    print("returnLinksArray")

                    if let array = returnLinksArray {
                        print("returnLinksArray")
                        self.linksArray = array
                        self.isLoading = false
                        DispatchQueue.main.async {
                            self.googleSearchButton.setTitle("Google Search", for: .normal)
                            self.googleSearchButton.backgroundColor = .green
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        } else {
            print("add text to search bar")
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

