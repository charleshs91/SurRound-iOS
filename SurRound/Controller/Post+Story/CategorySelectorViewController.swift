//
//  CategorySelectorViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/5.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class CategorySelectorViewController: UIViewController {
    
    static func storyboardInstance() -> CategorySelectorViewController? {
        return UIStoryboard.newPost.instantiateViewController(
            identifier: String(describing: CategorySelectorViewController.self)
            ) as? CategorySelectorViewController
    }
    
    @IBOutlet weak var btnsCollectionView: UICollectionView!
    
    @IBOutlet var popUpView: UIView!
    
    // Private Constants
    private let popUpViewHeight: CGFloat = 275
    
    private let categories: [PostCategory] = [.chat, .question, .food, .scenary, .shopping, .cancel]
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blurViewColor
        popUpView.backgroundColor = UIColor.hexStringToUIColor(hex: "FBFFE6")
        setupCollectionView()
        stylePopUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentPopUpView()
    }
    
    // MARK: - User Actions
    @objc func didTapCloseBtn(_ sender: UIControl) {
        
        dismissPopUpView()
    }
    
    @objc func didTapCategoryBtn(_ sender: UIControl) {
        
        guard let nav = UIStoryboard.newPost.instantiateInitialViewController() as? UINavigationController,
            let newPostVC = nav.viewControllers.first as? NewPostViewController else { return }
        
        let category = categories[sender.tag]
        
        newPostVC.postCategory = category
        
        dismissThenPresent(nav)
    }
    
    // MARK: - Private Methods
    private func setupCollectionView() {
        btnsCollectionView.registerCell(cellWithClass: CategoryButtonCell.self)
        
        btnsCollectionView.backgroundColor = .clear
        btnsCollectionView.stickToView(popUpView)
    }
    
    private func stylePopUpView() {
        popUpView.layer.setShadow(radius: 3,
                                  offset: CGSize(width: 3, height: -3),
                                  color: .darkGray,
                                  opacity: 0.7)
    }
    
    private func presentPopUpView() {
        
        popUpView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        popUpView.layer.cornerRadius = 16
        // initial position of popUpView
        popUpView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: popUpViewHeight)
        view.addSubview(popUpView)
        
        UIViewPropertyAnimator(
            duration: 0.3,
            curve: .easeInOut,
            animations: {
                self.popUpView.transform = CGAffineTransform(translationX: 0,
                                                             y: -self.popUpView.frame.height)
        }
        ).startAnimation()
    }
    
    private func dismissPopUpView(completion: (() -> Void)? = nil) {
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.popUpView.transform = .identity
        }, completion: { _ in
            self.popUpView.removeFromSuperview()
            self.presentingViewController?.dismiss(animated: false, completion: completion)
        })
    }
    
    private func dismissThenPresent(_ viewController: UIViewController) {
        
        dismissPopUpView(completion: {
            let rootVC = AppDelegate.shared.window!.rootViewController!
            viewController.modalPresentationStyle = .overCurrentContext
            rootVC.present(viewController, animated: true, completion: nil)
        })
    }
}

// MARK: - UICollectionViewDataSource
extension CategorySelectorViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryButtonCell.reuseIdentifier, for: indexPath)
        guard let btnCell = cell as? CategoryButtonCell else { return cell }
        
        let category = categories[indexPath.item]
        btnCell.layoutCell(image: category.image, title: category.text, tag: indexPath.item)
        
        if category != .cancel {
            btnCell.button.addTarget(self, action: #selector(didTapCategoryBtn(_:)), for: .touchUpInside)
        } else {
            btnCell.button.addTarget(self, action: #selector(didTapCloseBtn(_:)), for: .touchUpInside)
        }
        
        return btnCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategorySelectorViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.width / 4.5
        return CGSize(width: width, height: width)
    }
}
