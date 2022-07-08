//
//  SettingsViewController.swift
//  kdmobile
//
//  Created by Admin on 17.06.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    let userDefaults = UserDefaults.standard
    var tabBarDelegate: TabBarCurrentViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = userDefaults.string(forKey: UserDefaultsKeys.userName)
    }
    
    private func setupNavigationBar() {
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let newItem = UIBarButtonItem.init(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .done, target: self, action: #selector(self.didTapExitButton))
        newItem.tintColor = .black
        self.navigationItem.setRightBarButton(newItem, animated: true)
        
    }
    
    @objc private func didTapExitButton() {
        
        self.dismiss(animated: false, completion: nil)
        
        userDefaults.removeObject(forKey: UserDefaultsKeys.userName)
        userDefaults.removeObject(forKey: UserDefaultsKeys.password)
        userDefaults.removeObject(forKey: UserDefaultsKeys.isAuthorized)
            
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: false, completion: nil)
        
        tabBarDelegate?.setMainViewControllerToCurrent()
        
    }
    
}
