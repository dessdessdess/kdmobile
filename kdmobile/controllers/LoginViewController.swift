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
                        
        self.loginView.scrollView.contentOffset = CGPoint(x: 0, y: -1*(self.loginView.frame.height-self.keyboardHeight-self.loginView.scrollView.contentSize.height))
        
    }
    
    @objc private func keyboardWillHide() {
        self.loginView.scrollView.contentOffset = CGPoint.zero
    }
    
    //MARK: - business logic
    func loginButtonTapped() {
        
        guard let userName = self.loginView.userNameTextField.text, let password = self.loginView.passwordTextField.text else { return }
        let loginString = "\(userName):\(password)"
        guard let loginData = loginString.data(using: String.Encoding.utf8) else { return }
        let base64LoginString = loginData.base64EncodedString()
        
        NetworkManager.configuredNetworkManager().auth(with: base64LoginString) {
            
            [weak self] statusCode in
            
            if statusCode == 200 {
                
                self?.saveAuthorizationData(userName: userName, password: password)
                self?.dismiss(animated: true, completion: nil)
                
            } else {
                
                self?.loginView.userNameTextField.shake()
                self?.loginView.passwordTextField.shake()
                
            }
            
        }
        
    }
    
    private func saveAuthorizationData(userName: String, password: String) {
      
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: UserDefaultsKeys.isAuthorized)
        userDefaults.set(userName, forKey: UserDefaultsKeys.userName)
        userDefaults.set(password, forKey: UserDefaultsKeys.password)
        
    }
    
}


