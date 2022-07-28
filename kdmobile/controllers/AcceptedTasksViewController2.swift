//
//  AcceptedTasksViewController2.swift
//  kdmobile
//
//  Created by Admin on 27.07.2022.
//

import UIKit

class AcceptedTasksViewController2: UIViewController, AfterLoadDataFromNetwork {
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let dataManager = DataManager()
    var sectionIndex:Int = 0
    private var section = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.section = mainButtons[self.sectionIndex]
        self.navigationItem.title = "\(self.section) (В работе)"
        
        self.configureTableView()
        self.setupSubViews()
        self.activateConstraints()
                
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
    
    @objc private func getAcceptedTasks() {
        
        let networkManager = NetworkManager(vc: self)
        networkManager.getAcceptedTasks(vc: self, dataManager: self.dataManager)
          
    }
    
    func tableViewEndRefreshing() {
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
        
}

extension AcceptedTasksViewController2: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataManager.getAcceptedTasksCount(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "tasksListTableViewCell", for: indexPath) as? TasksListTableViewCell else { return UITableViewCell() }
        let acceptedTask = dataManager.getAcceptedTask(indexPath: indexPath)
        cell.setup(with: acceptedTask, selected: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailTaskViewController()
        detailVC.dataManager = dataManager
        detailVC.acceptedTask = dataManager.getAcceptedTask(indexPath: indexPath)
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataManager.deleteAcceptedTask(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
}
