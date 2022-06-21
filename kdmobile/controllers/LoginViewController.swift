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
        //serviceView.backgroundColor = .red
        return serviceView
    }()
    
    private let loginTextField: UITextField = {
        let loginTextField = UITextField()
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        loginTextField.placeholder = "Логин"
        loginTextField.font = UIFont.systemFont(ofSize: 15)
        loginTextField.borderStyle = UITextField.BorderStyle.roundedRect
        loginTextField.autocorrectionType = UITextAutocorrectionType.no
        //loginTextField.keyboardType = UIKeyboardType.default
        loginTextField.returnKeyType = UIReturnKeyType.done
        loginTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        loginTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        return loginTextField
    }()
    
    private let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Пароль"
        passwordTextField.font = UIFont.systemFont(ofSize: 15)
        passwordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        passwordTextField.autocorrectionType = UITextAutocorrectionType.no
        //passwordTextField.keyboardType = UIKeyboardType.default
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
        self.scrollView.addSubview(self.loginTextField)
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
            
            self.loginTextField.heightAnchor.constraint(equalToConstant: 50),
            self.loginTextField.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 60),
            self.loginTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20),
            self.loginTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            self.passwordTextField.topAnchor.constraint(equalTo: self.loginTextField.bottomAnchor, constant: 5),
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
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}


