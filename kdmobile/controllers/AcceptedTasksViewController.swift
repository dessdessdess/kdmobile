//
//  AcceptedTasksViewController.swift
//  kdmobile
//
//  Created by Admin on 28.06.2022.
//

import UIKit

class AcceptedTasksViewController: UIViewController {   
    
    private let tableView = UITableView()
    private var acceptedTasksData: [AcceptedTaskModel] = []
    private let refreshControl = UIRefreshControl()
    var sectionIndex:Int = 0
    private var section = ""
    private let decoder = JSONDecoder()
    private let network = Network()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.section = mainButtons[self.sectionIndex]
        self.navigationItem.title = "\(self.section) (В работе)"
        
        self.configureTableView()
        self.setupSubViews()
        self.activateConstraints()
        
        self.loadSavedAcceptedTasks()
        
    }
    
    private func configureTableView() {
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.register(TasksListTableViewCell.self, forCellReuseIdentifier: "tasksListTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Идет загрузка...")
        self.refreshControl.addTarget(self, action: #selector(self.getAcceptedTasks), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl)
        
    }
    
    private func setupSubViews() {
        self.view.addSubview(self.tableView)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
    private func loadSavedAcceptedTasks() {
        if let acceptedTasksData = UserDefaults.standard.object(forKey: UserDefaultsKeys.acceptedTasks) as? Data,
           let acceptedTasks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(acceptedTasksData) as? [AcceptedTaskModel] {
            self.acceptedTasksData = acceptedTasks
        }
    }
    
    @objc private func getAcceptedTasks() {
        
        let params = ["GUIDСклада": "313dd8f4-b47f-11eb-bbaa-c81f66f5fe1a",
                      "GUIDПользователя": "eaf3c420-11c1-11e6-814f-c81f66f5f5a5"]
        guard let request = network.getRequest(with: params, section: self.section, type: "AcceptedTasks") else { return }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    
                    if let data = data {
                                                
                        guard let acceptedDataTasksFromNetwork = try? self.decoder.decode(AcceptedTaskCommonModel.self, from: data) else { return }
                        
                        for item in acceptedDataTasksFromNetwork.docsArray {
                            if !self.acceptedTasksData.contains(where: {$0.guid == item.guid}) {
                                self.acceptedTasksData.append(item)
                            }
                        }
                        
                        //self.acceptedTasksData = acceptedDataTasksFromNetwork.docsArray
                        self.acceptedTasksData.sort(by: <)
                        
                        DispatchQueue.main.async {
                            
                            self.refreshControl.endRefreshing()
                            self.tableView.reloadData()
                            self.saveData()
                                                                                    
                        }
                        
                    }
                                        
                } else {
                    
                    print(httpResponse.statusCode)
                    
                }
            }
        }
               
        task.resume()
        
    }
        
    func saveData() {
        let acceptedTasksData = try? NSKeyedArchiver.archivedData(withRootObject: self.acceptedTasksData, requiringSecureCoding: false)
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(acceptedTasksData, forKey: UserDefaultsKeys.acceptedTasks)
    }
    
}

extension AcceptedTasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.acceptedTasksData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "tasksListTableViewCell", for: indexPath) as? TasksListTableViewCell else { return UITableViewCell() }
        let acceptedTask = self.acceptedTasksData[indexPath.row]
        cell.setup(with: acceptedTask, selected: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailTaskViewController()
        detailVC.delegate = self
        detailVC.acceptedTask = acceptedTasksData[indexPath.row]
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
