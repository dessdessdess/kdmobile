//
//  TabBarController.swift
//  kdmobile
//
//  Created by Admin on 17.06.2022.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = .systemBlue
                
        let mainVC = MainViewController()
        mainVC.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "bolt"), tag: 0)
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gearshape"), tag: 1)
        
        self.setViewControllers([
            UINavigationController(rootViewController: mainVC),
            UINavigationController(rootViewController: settingsVC)
        ], animated: true)
        
    }
}
