//
//  LoginViewController.swift
//  kdmobile
//
//  Created by Admin on 17.06.2022.
//

import UIKit

class LoginViewController: UIViewController, LoginViewProtocol {
     
    //MARK: - properties
    let loginView = LoginView()
    private var keyboardHeight:CGFloat = 0
    
    //MARK: - view lifecycle
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loginView.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
    }
            
    @objc private func viewTapped() {
        self.view.endEditing(true)
    }
    
    //MARK: - keyboard working
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        
        if self.keyboardHeight == 0 {
            guard let userInfo = notification.userInfo else { return }
            let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            self.keyboardHeight = keyboardFrame.size.height
        }
        
        self.loginView.scrollView.contentOffset.y = self.loginView.scrollView.contentSize.height - (self.loginView.scrollView.frame.height - self.keyboardHeight) //+ 20
        
    }
    
    @objc private func keyboardWillHide() {
        self.loginView.scrollView.contentOffset.y = 0
    }
    
    //MARK: - bussines logic
    func loginButtonTapped() {
        guard let userName = self.loginView.userNameTextField.text, let password = self.loginView.passwordTextField.text else { return }
        let loginString = "\(userName):\(password)"
        guard let loginData = loginString.data(using: String.Encoding.utf8) else { return }
    
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "http://192.168.11.30/Brinex_abzanov.r/hs/StoragePointV2/Test") else { return }
                
        var request = URLRequest(url: url,timeoutInterval: 30)
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    
                    self.saveAuthorizationData(userName: userName, password: password)
                    
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                } else {
                    
                    DispatchQueue.main.async {
                        self.loginView.userNameTextField.shake()
                        self.loginView.passwordTextField.shake()
                        
                    }
                    
                }
            }
                                    
        }
        
        task.resume()
    }
    
    private func saveAuthorizationData(userName: String, password: String) {
      
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: UserDefaultsKeys.isAuthorized)
        userDefaults.set(userName, forKey: UserDefaultsKeys.userName)
        userDefaults.set(password, forKey: UserDefaultsKeys.password)
        
    }
    
}


