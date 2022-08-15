//
//  MainViewController.swift
//  kdmobile
//
//  Created by Admin on 17.06.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.navigationItem.title = "KD Mobile 2.0"
        self.navigationItem.backButtonTitle = "Назад"
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "008e55")
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.setupSubviews()
        self.activateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        let userDefaults = UserDefaults.standard
        let isAuthorized = userDefaults.bool(forKey: UserDefaultsKeys.isAuthorized)
        
        if isAuthorized == false {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false, completion: nil)
        }
    }
    
    private lazy var collectionView: UICollectionView = {
       
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumLineSpacing = 20
        collectionViewLayout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        return collectionView
        
    }()
    
    private func setupSubviews() {
        self.view.addSubview(collectionView)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func itemSize(for width: CGFloat, with spacing: CGFloat) -> CGSize {
        
        let neededWidth = width - 2 * spacing
        let itemWidth = floor(neededWidth / 2) // 2 элемента в ряду
        return CGSize(width: itemWidth, height: itemWidth*0.8)
        
    }
    
    @objc private func mainButtonTapped(sender: MainButtonTapGestureReconizer) {
        guard let sectionIndex = sender.indexPath?.row else { return }
        let sectionSelectionVC = SectionSelectionViewController()
        sectionSelectionVC.sectionIndex = sectionIndex
        navigationController?.pushViewController(sectionSelectionVC, animated: true)
        
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainButtons.mainButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            cell.backgroundColor = .systemRed
            return cell
        }
        cell.setupTitle(title: MainButtons.mainButtons[indexPath.row])
        let mainButtonTapGestureRecognizer = MainButtonTapGestureReconizer(target:self, action: #selector(self.mainButtonTapped))
        mainButtonTapGestureRecognizer.indexPath = indexPath
        cell.addGestureRecognizer(mainButtonTapGestureRecognizer)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let spacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing
        return self.itemSize(for: collectionView.frame.width, with: spacing ?? 0)
        
    }
    
}

class MainButtonTapGestureReconizer: UITapGestureRecognizer {
    var indexPath: IndexPath?
}
