//
//  TasksViewController.swift
//  kdmobile
//
//  Created by Admin on 28.06.2022.
//

import UIKit

class TasksViewController: UIViewController {

    private let tableView = UITableView()
    private var tasksData: [TaskModel] = []
    private let refreshControl = UIRefreshControl()
    var sectionIndex:Int = 0
    private var section = ""
//    private let decoder = JSONDecoder()
//    private let network = Network()
    private let networkManager = NetworkManager.configuredNetworkManager()
    private var selectedTasks: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.section = MainButtons.mainButtons[self.sectionIndex]
        self.navigationItem.title = "Задания на \(MainButtons.mainButtonsDeclinationTasks[self.section] ?? "")"
        
        self.configureTableView()
        self.setupSubViews()
        self.activateConstraints()
        
    }
    
    private let acceptButton: UIButton = {
        let acceptButton = UIButton()
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.setTitle("Принять задания", for: .normal)
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.backgroundColor = UIColor(hexString: "008e55")
        acceptButton.layer.cornerRadius = 5
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        return acceptButton
    }()
        
    private func configureTableView() {
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.register(TasksListTableViewCell.self, forCellReuseIdentifier: "tasksListTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Идет загрузка...")
        self.refreshControl.addTarget(self, action: #selector(self.getTasks), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl)
                   
    }
    
    private func setupSubViews() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.acceptButton)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            
            self.acceptButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.acceptButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.acceptButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            self.acceptButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.acceptButton.topAnchor, constant: -20),
                      
        ])
    }
    
    @objc private func getTasks() {
        
        networkManager.getTasks { [weak self] dataTasksFromNetwork in
            
            guard let dataTasksFromNetwork = dataTasksFromNetwork else {
                
                self?.refreshControl.endRefreshing()
                return
                
            }
            
            self?.tasksData = dataTasksFromNetwork
            self?.tasksData.sort(by: <)
            
            self?.selectedTasks.removeAll()
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
            self?.setAcceptButtonTitle()
            
        }
        
    }
    
    @objc private func acceptButtonTapped() {
        if self.selectedTasks.isEmpty {
            return
        }
        
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        present(loadingVC, animated: true, completion: nil)
                        
        var selectedTasksToTransfer:[[String:String]] = []
        
        for index in self.selectedTasks {
           
            let task = ["ВидДокумента":self.tasksData[index].documentType,
                        "GUID":self.tasksData[index].guid]
            
            selectedTasksToTransfer.append(task)
             
        }
                
        networkManager.acceptTasks(selectedTasksToTransfer: selectedTasksToTransfer) { [weak self] in
            self?.getTasks()
            loadingVC.dismiss(animated: false, completion: nil)
        }
        
    }
    
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasksData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "tasksListTableViewCell", for: indexPath) as? TasksListTableViewCell else { return UITableViewCell() }
        let selected = self.selectedTasks.contains(indexPath.row)
        let task = self.tasksData[indexPath.row]
        cell.setup(with: task, selected: selected)
        return cell
    }
    
    fileprivate func setAcceptButtonTitle() {
        let selectedTaskCount = self.selectedTasks.count
        if selectedTaskCount == 0 {
            self.acceptButton.setTitle("Принять задания", for: .normal)
        } else {
            self.acceptButton.setTitle("Принять задания (\(selectedTaskCount))", for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedTasks.contains(indexPath.row) {
            self.selectedTasks.removeAll(where: {$0 == indexPath.row})
        } else {
            self.selectedTasks.append(indexPath.row)
        }
        
        self.tableView.reloadRows(at: [indexPath], with: .none)
        
        self.setAcceptButtonTitle()
        
    }
    
}
