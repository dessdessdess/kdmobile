//
//  DetailTaskHeader.swift
//  kdmobile
//
//  Created by Admin on 08.07.2022.
//

import UIKit

class DetailTaskHeader: UIView {

    private let detailTaskHeaderData: DetailTaskHeaderModel
    
    required init(detailTaskHeaderData: DetailTaskHeaderModel) {
        self.detailTaskHeaderData = detailTaskHeaderData
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupSubviews()
        self.activateConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let clientLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 24)
        //label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let documentTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupSubviews() {
        self.clientLabel.text = self.detailTaskHeaderData.client
        self.addSubview(self.clientLabel)
        self.numberLabel.text = self.detailTaskHeaderData.number
        self.addSubview(self.numberLabel)
        self.dateLabel.text = TaskModel.getFormatDate(dateToFormat: self.detailTaskHeaderData.date) 
        self.addSubview(self.dateLabel)
        self.documentTypeLabel.text = self.detailTaskHeaderData.documentType
        self.addSubview(self.documentTypeLabel)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            self.clientLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.clientLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.clientLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            self.documentTypeLabel.topAnchor.constraint(equalTo: self.clientLabel.bottomAnchor, constant: 5),
            self.documentTypeLabel.leadingAnchor.constraint(equalTo: self.clientLabel.leadingAnchor),
            
            self.numberLabel.leadingAnchor.constraint(equalTo: self.clientLabel.leadingAnchor),
            self.numberLabel.topAnchor.constraint(equalTo: self.documentTypeLabel.bottomAnchor, constant: 5),
            
            self.dateLabel.trailingAnchor.constraint(equalTo: self.clientLabel.trailingAnchor),
            self.dateLabel.topAnchor.constraint(equalTo: self.documentTypeLabel.bottomAnchor, constant: 5),
            self.dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                        
        ])
    }
    
}
