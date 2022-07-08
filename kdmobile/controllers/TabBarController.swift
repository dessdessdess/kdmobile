//
//  TabBarController.swift
//  kdmobile
//
//  Created by Admin on 17.06.2022.
//

import UIKit

class TabBarController: UITabBarController, TabBarCurrentViewController {
    
    let mainVC = MainViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor(hexString: "008e55")
            
        self.mainVC.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "bolt"), tag: 0)
        let settingsVC = SettingsViewController()
        settingsVC.tabBarDelegate = self
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gearshape"), tag: 1)
        
        self.setViewControllers([
            UINavigationController(rootViewController: self.mainVC),
            UINavigationController(rootViewController: settingsVC)
        ], animated: true)
            
    }
    
    func setMainViewControllerToCurrent() {
        self.selectedIndex = 0
        self.mainVC.navigationController?.popToRootViewController(animated: false)
    }
}

protocol TabBarCurrentViewController {
    func setMainViewControllerToCurrent()
}
