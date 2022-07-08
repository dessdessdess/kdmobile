//
//  SectionSelectionViewController.swift
//  kdmobile
//
//  Created by Admin on 27.06.2022.
//

import UIKit

class SectionSelectionViewController: UIViewController {

    var sectionIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.navigationItem.title = mainButtons[self.sectionIndex]
        self.navigationItem.backButtonTitle = ""
        self.setupSubviews()
        self.activateConstraints()
        
    }
    
    private lazy var showTasksButton: UIButton = {
        
        let showTasksButton = UIButton()
        showTasksButton.translatesAutoresizingMaskIntoConstraints = false
        showTasksButton.setTitle("Задания на \(mainButtonsDeclinationTasks[mainButtons[self.sectionIndex]] ?? "")", for: .normal)
        showTasksButton.setTitleColor(.white, for: .normal)
        showTasksButton.backgroundColor = UIColor(hexString: "008e55")
        showTasksButton.layer.cornerRadius = 10
        showTasksButton.addTarget(self, action: #selector(showTasksButtonTapped), for: .touchUpInside)
        return showTasksButton
        
    }()
    
    private lazy var showAcceptedTasksButton: UIButton = {
        
        let showAcceptedTasksButton = UIButton()
        showAcceptedTasksButton.translatesAutoresizingMaskIntoConstraints = false
        showAcceptedTasksButton.setTitle("Приступить к \(mainButtonsDeclinationAcceptedTasks[mainButtons[self.sectionIndex]] ?? "")", for: .normal)
        showAcceptedTasksButton.setTitleColor(.white, for: .normal)
        showAcceptedTasksButton.backgroundColor = UIColor(hexString: "008e55")
        showAcceptedTasksButton.layer.cornerRadius = 10
        showAcceptedTasksButton.addTarget(self, action: #selector(showAcceptedTasksButtonTapped), for: .touchUpInside)
        return showAcceptedTasksButton
        
    }()
    
    private func setupSubviews() {
        self.view.addSubview(self.showTasksButton)
        self.view.addSubview(self.showAcceptedTasksButton)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            
            self.showTasksButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.showTasksButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -35),
            self.showTasksButton.heightAnchor.constraint(equalToConstant: 50),
            self.showTasksButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.showTasksButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            self.showAcceptedTasksButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.showAcceptedTasksButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 35),
            self.showAcceptedTasksButton.heightAnchor.constraint(equalTo: self.showTasksButton.heightAnchor),
            self.showAcceptedTasksButton.leadingAnchor.constraint(equalTo: self.showTasksButton.leadingAnchor),
            self.showAcceptedTasksButton.trailingAnchor.constraint(equalTo: self.showAcceptedTasksButton.trailingAnchor)
            
        ])
    }
    
    @objc private func showTasksButtonTapped() {
        let tasksVC = TasksViewController()
        tasksVC.sectionIndex = self.sectionIndex
        self.navigationController?.pushViewController(tasksVC, animated: true)
    }
    
    @objc private func showAcceptedTasksButtonTapped() {
        let acceptedTasksVC = AcceptedTasksViewController()
        acceptedTasksVC.sectionIndex = self.sectionIndex
        self.navigationController?.pushViewController(acceptedTasksVC, animated: true)
    }
    
}
