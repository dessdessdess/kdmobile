//
//  DetailTaskViewController.swift
//  kdmobile
//
//  Created by Admin on 07.07.2022.
//

import UIKit

class DetailTaskViewController: UIViewController {

    lazy var delegate: AcceptedTasksViewController? = nil
    lazy var acceptedTask: AcceptedTaskModel? = nil
    private lazy var detailTaskHeader = UIView()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "В работе"
        self.setupBarButtonItem()
        self.configureTableView()
        self.setupSubviews()
        self.activateConstraints()
    }
    
    private func setupBarButtonItem() {
        let newItem = UIBarButtonItem.init(image: UIImage(systemName: "qrcode.viewfinder"), style: .done, target: self, action: #selector(self.didTapScanButton))
        self.navigationItem.setRightBarButton(newItem, animated: true)
    }
    
    @objc private func didTapScanButton() {
        let alert = UIAlertController(title: "Внимание",
                                      message: "Должна запуститься камера для сканирования КМ",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupSubviews() {
        
        guard let acceptedTask = self.acceptedTask else {
            return
        }
         
        let detailTaskHeaderModel = DetailTaskHeaderModel(number: acceptedTask.number,
                                                          date: acceptedTask.date ,
                                                          documentType: acceptedTask.documentType,
                                                          client: acceptedTask.client)
        self.detailTaskHeader = DetailTaskHeader(detailTaskHeaderData: detailTaskHeaderModel)
        
        self.view.addSubview(self.detailTaskHeader)
        self.view.addSubview(self.tableView)
        
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            self.detailTaskHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.detailTaskHeader.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.detailTaskHeader.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.detailTaskHeader.bottomAnchor, constant: 8),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    private func configureTableView() {
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "productTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableView.automaticDimension
                
    }
    
}

extension DetailTaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.acceptedTask?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productTableViewCell") as! ProductTableViewCell
        let product = self.acceptedTask?.products[indexPath.row]
        cell.setup(product: product!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentProduct = self.acceptedTask?.products[indexPath.row] {
            if currentProduct.scanCount < currentProduct.count {
                currentProduct.scanCount += 1
                self.tableView.reloadRows(at: [indexPath], with: .none)
                self.delegate?.saveData()
            }
        }
        
    }
    
}
