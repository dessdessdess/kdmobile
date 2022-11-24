//
//  AcceptedTasksViewController2.swift
//  kdmobile
//
//  Created by Admin on 27.07.2022.
//

import UIKit

class AcceptedTasksViewController2: UIViewController {
       
    private lazy var dataManager = DataManager.configuredDataManager()
    private lazy var tableView = UITableView()
    private lazy var refreshControl = UIRefreshControl()
    var sectionIndex:Int = 0
    private lazy var section = ""
    private var searchController = UISearchController(searchResultsController:  nil)
    private var filteredAcceptedTasks = [AcceptedTask]()
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.section = MainButtons.mainButtons[self.sectionIndex]
        self.navigationItem.title = "\(self.section) (В работе)"
                   
        self.configureTableView()
        self.configureSearchBar()
        self.setupSubViews()
        self.activateConstraints()
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
    }
    
    private func configureSearchBar() {
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.showsCancelButton = true
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar)), animated: true)
        
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
        
    @objc private func showSearchBar() {

        self.navigationItem.rightBarButtonItems?.removeAll()
        self.searchController.isActive = true
        self.navigationItem.titleView = searchController.searchBar
        self.navigationItem.titleView?.becomeFirstResponder()
                   
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let tabBarHeight = CGFloat(UserDefaults.standard.integer(forKey: "tabBarHeight"))
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight-tabBarHeight, right: 0)
            self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight-tabBarHeight, right: 0)
                        
        }
    }
    
    @objc private func getAcceptedTasks() {
        
        NetworkManager.configuredNetworkManager().getAcceptedTasks(completion: { [weak self] acceptedTasksName in
            
            guard let strongSelf = self else { return }
            
            if let acceptedTasksName = acceptedTasksName {
                for item in acceptedTasksName {
                    if !strongSelf.dataManager.containsAcceptedTask(guid: item.guid) {
                        strongSelf.dataManager.createAcceptedTask(acceptedTask: item)
                    }
                }
            }
            
            strongSelf.tableView.reloadData()
            strongSelf.refreshControl.endRefreshing()
            
        })
        
    }
                  
}

extension AcceptedTasksViewController2: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return filteredAcceptedTasks.count
        } else {
            return dataManager.getAcceptedTasksCount(section: section)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "tasksListTableViewCell", for: indexPath) as? TasksListTableViewCell else { return UITableViewCell() }
        
        var acceptedTask: AcceptedTask
        
        if self.searchController.isActive {
            acceptedTask = filteredAcceptedTasks[indexPath.row]
        } else {
            acceptedTask = dataManager.getAcceptedTask(indexPath: indexPath)
        }
        
        cell.setup(with: acceptedTask, selected: false)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailTaskViewController()
        detailVC.dataManager = self.dataManager
        if searchController.isActive {
            detailVC.acceptedTask = filteredAcceptedTasks[indexPath.row]
        } else {
            detailVC.acceptedTask = dataManager.getAcceptedTask(indexPath: indexPath)
        }
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

extension AcceptedTasksViewController2:  UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else {
            return
        }
        
        if text.isEmpty {
            filteredAcceptedTasks = dataManager.getAllAcceptedTasks()
        } else {
            filteredAcceptedTasks = dataManager.getAcceptedTasks(with: text)
        }
                
        tableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.navigationItem.titleView = nil
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar)), animated: true)
        self.searchController.isActive = false
        
        tableView.reloadData()
        
        self.tableView.contentInset = UIEdgeInsets.zero
        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets.zero
        
    }
}
