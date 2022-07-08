//
//  LoginViewController.swift
//  kdmobile
//
//  Created by Admin on 17.06.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .gray
        self.setupSubViews()
        self.activateConstraints()
        
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
    
    private var keyboardHeight:CGFloat = 0
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private let logoImageView: UIImageView = {
        let logo = UIImageView(image: UIImage(named: "brinex"))
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    
    private let serviceView: UIView = {
        let serviceView = UIView()
        serviceView.translatesAutoresizingMaskIntoConstraints = false
        return serviceView
    }()
    
    private let userNameTextField: UITextField = {
        let userNameTextField = UITextField()
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        userNameTextField.placeholder = "Логин"
        userNameTextField.font = UIFont.systemFont(ofSize: 15)
        userNameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        userNameTextField.autocorrectionType = UITextAutocorrectionType.no
        userNameTextField.returnKeyType = UIReturnKeyType.done
        userNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        userNameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        return userNameTextField
    }()
    
    private let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "Пароль"
        passwordTextField.font = UIFont.systemFont(ofSize: 15)
        passwordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        passwordTextField.autocorrectionType = UITextAutocorrectionType.no
        passwordTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        passwordTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        return passwordTextField
    }()
    
    private let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor(hexString: "008e55")
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        return loginButton
    }()
    
    private func setupSubViews() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.serviceView)
        self.serviceView.addSubview(self.logoImageView)
        self.scrollView.addSubview(self.userNameTextField)
        self.scrollView.addSubview(self.passwordTextField)
        self.scrollView.addSubview(self.loginButton)
    }
    
    private func activateConstraints() {
        
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.serviceView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.serviceView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.serviceView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.serviceView.bottomAnchor.constraint(equalTo: self.scrollView.centerYAnchor),
            
            self.logoImageView.heightAnchor.constraint(equalToConstant: 140),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 200),
            self.logoImageView.centerXAnchor.constraint(equalTo: self.serviceView.centerXAnchor),
            self.logoImageView.centerYAnchor.constraint(equalTo: self.serviceView.centerYAnchor),
            
            self.userNameTextField.heightAnchor.constraint(equalToConstant: 50),
            self.userNameTextField.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 60),
            self.userNameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20),
            self.userNameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            self.passwordTextField.topAnchor.constraint(equalTo: self.userNameTextField.bottomAnchor, constant: 5),
            self.passwordTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20),
            self.passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            self.loginButton.heightAnchor.constraint(equalToConstant: 50),
            self.loginButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 20),
            self.loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20),
            self.loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.loginButton.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -20)
            
        ])
    }
    
    @objc private func viewTapped() {
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        
        if self.keyboardHeight == 0 {
            guard let userInfo = notification.userInfo else { return }
            let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            self.keyboardHeight = keyboardFrame.size.height
        }
        
        //        self.scrollView.contentInset.bottom = keyboardHeight + 20
        //        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
        self.scrollView.contentOffset.y = self.scrollView.contentSize.height - (self.scrollView.frame.height - self.keyboardHeight) //+ 20
        
    }
    
    @objc private func keyboardWillHide() {
        
        //        self.scrollView.contentInset.bottom = 0
        //        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
        self.scrollView.contentOffset.y = 0
        
    }
    
    @objc private func loginPressed() {
        
        guard let userName = userNameTextField.text, let password = passwordTextField.text else { return }
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
                        self.userNameTextField.shake()
                        self.passwordTextField.shake()
                        
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


