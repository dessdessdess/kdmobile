//
//  ProductTableViewCell.swift
//  kdmobile
//
//  Created by Admin on 18.07.2022.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupSubviews()
        self.activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let nomenclatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .italicSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    private let characteristicLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .italicSystemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = .italicSystemFont(ofSize: 16)
        return label
    }()
    
    private let scanCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = .italicSystemFont(ofSize: 16)
        return label
    }()
    
    private let unitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .italicSystemFont(ofSize: 12)
        return label
    }()
    
    private func setupSubviews() {
        self.contentView.addSubview(self.nomenclatureLabel)
        self.contentView.addSubview(self.characteristicLabel)
        self.contentView.addSubview(self.countLabel)
        self.contentView.addSubview(self.scanCountLabel)
        self.contentView.addSubview(self.unitLabel)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            self.nomenclatureLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.nomenclatureLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.nomenclatureLabel.trailingAnchor.constraint(equalTo: self.countLabel.leadingAnchor, constant: -16),
            
            self.characteristicLabel.leadingAnchor.constraint(equalTo: self.nomenclatureLabel.leadingAnchor),
            self.characteristicLabel.topAnchor.constraint(equalTo: self.nomenclatureLabel.bottomAnchor, constant: 5),
            self.characteristicLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            
            self.countLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.countLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            self.scanCountLabel.topAnchor.constraint(equalTo: self.countLabel.bottomAnchor),
            self.scanCountLabel.trailingAnchor.constraint(equalTo: self.countLabel.trailingAnchor),
            
            self.unitLabel.topAnchor.constraint(equalTo: self.scanCountLabel.bottomAnchor),
            self.unitLabel.trailingAnchor.constraint(equalTo: self.scanCountLabel.trailingAnchor),
            self.unitLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
            
        ])
    }
    
    func setup(product: ProductS) {
        self.nomenclatureLabel.text = product.nomenclature
        self.characteristicLabel.text = product.characteristic
        self.countLabel.text = String(product.count)
        self.scanCountLabel.text = String(product.scanCount)
        self.unitLabel.text = product.unit
        
        if product.count == product.scanCount {
            self.contentView.backgroundColor = .systemGreen
        } else if
            product.scanCount != 0 {
            self.contentView.backgroundColor = .systemOrange
        }
        
        
    }
    
}
