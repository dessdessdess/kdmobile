//
//  LoginView.swift
//  kdmobile
//
//  Created by Admin on 11.08.2022.
//

import UIKit

protocol LoginViewProtocol: AnyObject {
    func loginButtonTapped()
}

class LoginView: UIView {
    
    weak var delegate: LoginViewProtocol?
    
    let scrollView: UIScrollView = {
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
    
    let userNameTextField: UITextField = {
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
    
    let passwordTextField: UITextField = {
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
    
    let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor(hexString: "008e55")
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return loginButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
        self.setupSubViews()
        self.activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.serviceView)
        self.serviceView.addSubview(self.logoImageView)
        self.scrollView.addSubview(self.userNameTextField)
        self.scrollView.addSubview(self.passwordTextField)
        self.scrollView.addSubview(self.loginButton)
    }
    
    private func activateConstraints() {
        
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.serviceView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.serviceView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.serviceView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.serviceView.bottomAnchor.constraint(equalTo: self.scrollView.centerYAnchor),
            
            self.logoImageView.heightAnchor.constraint(equalToConstant: 140),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 200),
            self.logoImageView.centerXAnchor.constraint(equalTo: self.serviceView.centerXAnchor),
            self.logoImageView.centerYAnchor.constraint(equalTo: self.serviceView.centerYAnchor),
            
            self.userNameTextField.heightAnchor.constraint(equalToConstant: 50),
            self.userNameTextField.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 20),
            self.userNameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            self.userNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            self.passwordTextField.topAnchor.constraint(equalTo: self.userNameTextField.bottomAnchor, constant: 5),
            self.passwordTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            self.passwordTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            self.loginButton.heightAnchor.constraint(equalToConstant: 50),
            self.loginButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 20),
            self.loginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            self.loginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.loginButton.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -20)
            
        ])
    }
    
    @objc func loginButtonTapped() {
        self.delegate?.loginButtonTapped()
    }
    
}
