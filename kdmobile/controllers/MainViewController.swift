//
//  MainViewController.swift
//  kdmobile
//
//  Created by Admin on 17.06.2022.
//

import UIKit

class MainViewController: UIViewController {

    private var dontOpened = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.dontOpened {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false, completion: nil)
            self.dontOpened = false
        }
    }
}
