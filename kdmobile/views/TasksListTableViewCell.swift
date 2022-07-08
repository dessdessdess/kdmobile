//
//  TaskTableViewCell.swift
//  kdmobile
//
//  Created by Admin on 29.06.2022.
//

import UIKit

protocol TaskModelProtocol {
    var number: String { get }
    var client: String { get }
    var documentType: String { get }
    var date: String { get }
    var guid: String { get }
}

class TasksListTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupSubviews()
        self.activateConstraints()
        let someView = UIView()
        someView.backgroundColor = UIColor(hexString: "008e55")
        self.selectedBackgroundView = someView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.clientLabel.text = nil
        self.documentTypeLabel.text = nil
        self.numberLabel.text = nil
        self.dateLabel.text = nil
    }
    
    private let clientLabel: UILabel = {
        let clientLabel = UILabel()
        clientLabel.translatesAutoresizingMaskIntoConstraints = false
        clientLabel.font = .systemFont(ofSize: 20, weight: .bold)
        clientLabel.numberOfLines = 2
        return clientLabel
    }()
    
    private let documentTypeLabel: UILabel = {
        let documentTypeLabel = UILabel()
        documentTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        return documentTypeLabel
    }()
    
    private let numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        return numberLabel
    }()
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    private func setupSubviews() {
        self.contentView.addSubview(self.clientLabel)
        self.contentView.addSubview(self.documentTypeLabel)
        self.contentView.addSubview(self.numberLabel)
        self.contentView.addSubview(self.dateLabel)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            
            self.clientLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.clientLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.clientLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            self.documentTypeLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.documentTypeLabel.topAnchor.constraint(equalTo: self.clientLabel.bottomAnchor, constant: 5),
            self.documentTypeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            self.numberLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.numberLabel.topAnchor.constraint(equalTo: self.documentTypeLabel.bottomAnchor, constant: 5),
                        
            self.dateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.dateLabel.topAnchor.constraint(equalTo: self.documentTypeLabel.bottomAnchor, constant: 5),
            self.dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
            
        ])
    }
    
    func setup(with taskModel: TaskModelProtocol, selected: Bool) {
        
        if selected {
            self.contentView.backgroundColor = UIColor(hexString: "008e55")
        } else {
            self.contentView.backgroundColor = .none
        }
        
        self.clientLabel.text = taskModel.client
        self.documentTypeLabel.text = taskModel.documentType
        self.numberLabel.text = taskModel.number
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: taskModel.date)!
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let stringDate = dateFormatter.string(from: date)
        self.dateLabel.text = stringDate
        
    }
    
}
