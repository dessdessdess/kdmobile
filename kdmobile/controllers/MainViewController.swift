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
        
        //self.navigationController?.barHideOnSwipeGestureRecognizer.addTarget(self, action: #selector(barHideOnSwipe))
        
        self.setupSubviews()
        self.activateConstraints()
    }
    
//    @objc private func barHideOnSwipe(sender: UIPanGestureRecognizer) {
//
//        //if let titleView = self.navigationItem.titleView {
//            // fade out title view when swiping up
//            let translation = sender.translation(in: self.view)
//            if(translation.y < 0) {
//                self.navigationController?.setNavigationBarHidden(true, animated: true)
//            } else {
//                self.navigationController?.setNavigationBarHidden(false, animated: true)
//            }
//            // clear transparency if the Navigation Bar is not hidden after swiping
////            if let navigationController = self.navigationController {
////                let navigationBar = navigationController.navigationBar
////                if navigationBar.frame.origin.y > 0 {
////                    if let titleView = self.navigationItem.titleView {
////                        titleView.alpha = 1
////                    }
////                }
////            }
//       // }
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.navigationController?.hidesBarsOnSwipe = true
                
        let userDefaults = UserDefaults.standard
        let isAuthorized = userDefaults.bool(forKey: UserDefaultsKeys.isAuthorized)
        
        if isAuthorized == false {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false, completion: nil)
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.hidesBarsOnSwipe = false
//        self.navigationController?.isNavigationBarHidden = false
//    }
    
    private lazy var collectionView: UICollectionView = {

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumLineSpacing = 16
        //collectionViewLayout.minimumInteritemSpacing = 16

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
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
//    private func itemSize(for width: CGFloat, with spacing: CGFloat) -> CGSize {
//
//        let neededWidth = width //- 1 * spacing //2
//        let itemWidth = floor(neededWidth) // 2 элемента в ряду
//        return CGSize(width: itemWidth, height: 60)//itemWidth*0.8)
//
//    }
    
    @objc private func mainButtonTapped(sender: MainButtonTapGestureRecognizer) {
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
        let mainButtonTapGestureRecognizer = MainButtonTapGestureRecognizer(target:self, action: #selector(self.mainButtonTapped))
        mainButtonTapGestureRecognizer.indexPath = indexPath
        cell.addGestureRecognizer(mainButtonTapGestureRecognizer)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        CGSize(width: collectionView.frame.width - 32, height: 60)
//        let spacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing
//        return self.itemSize(for: collectionView.frame.width, with: spacing ?? 0)
        
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if(velocity.y>0) {
//                //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
//            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions(), animations: {
//                    self.navigationController?.setNavigationBarHidden(true, animated: true)
//                    //self.navigationController?.setToolbarHidden(true, animated: true)
//                    print("Hide")
//                }, completion: nil)
//
//            } else {
//                UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions(), animations: {
//                    self.navigationController?.setNavigationBarHidden(false, animated: true)
//                    //self.navigationController?.setToolbarHidden(false, animated: true)
//                    print("Unhide")
//                }, completion: nil)
//              }
//    }
    
}

class MainButtonTapGestureRecognizer: UITapGestureRecognizer {
    var indexPath: IndexPath?
}
