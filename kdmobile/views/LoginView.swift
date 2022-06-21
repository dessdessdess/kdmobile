//
//  LoginView.swift
//  kdmobile
//
//  Created by Admin on 17.06.2022.
//

import UIKit

class LoginView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setupSubViews()
        self.activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private let logoImageView: UIImageView = {
        let logoImageView = UIImageView(image: UIImage(named: "brinex"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        return logoImageView
    }()
    
    private let loginTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Email or phone"
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.maskedCorners = [
            .layerMinXMinYCorner, .layerMaxXMinYCorner
        ]
        textField.clipsToBounds = true
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 5))
        textField.leftViewMode = .always
        
        
        
        return textField
    }()
    
    private func setupSubViews() {        
        self.addSubview(logoImageView)
        self.addSubview(loginTextField)
        loginTextField.frame = CGRect(x: 50, y: 500, width: 300, height: 50)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
                       
            self.logoImageView.widthAnchor.constraint(equalToConstant: 200),
            self.logoImageView.heightAnchor.constraint(equalToConstant: 140),
            self.logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
//            self.loginTextField.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 20),
//            self.loginTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
//            self.loginTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
//            self.loginTextField.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
}
