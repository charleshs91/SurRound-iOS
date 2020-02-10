//
//  StoryViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/7.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {

    private let progressBarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let clv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        clv.translatesAutoresizingMaskIntoConstraints = false
        clv.showsHorizontalScrollIndicator = false
        clv.showsVerticalScrollIndicator = false
        clv.backgroundColor = .clear
        return clv
    }()
    
    private let storyCollectionView: CubeAnimatedCollectionView = {
        let clv = CubeAnimatedCollectionView()
        clv.translatesAutoresizingMaskIntoConstraints = false
        clv.isPagingEnabled = true
        clv.showsHorizontalScrollIndicator = false
        clv.showsVerticalScrollIndicator = false
        clv.backgroundColor = .clear
        return clv
    }()
    
    var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    var stories = [Story]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCollectionViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - User Actions
    @objc func dismissStoryVC(_ sender: UIButton) {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    private func setupCollectionViews() {
        
        storyCollectionView.dataSource = self
        storyCollectionView.delegate = self
        storyCollectionView.stickToSafeArea(view)
        storyCollectionView.registerCellWithNib(cellWithClass: StoryDetailCollectionCell.self)
        
        progressBarCollectionView.dataSource = self
        progressBarCollectionView.delegate = self
        view.addSubview(progressBarCollectionView)
        progressBarCollectionView.setConstraints(
            to: view.safeAreaLayoutGuide, top: 0, leading: 0, trailing: 0)
        progressBarCollectionView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        progressBarCollectionView.registerCellWithNib(cellWithClass: StoryCounterCell.self)
    }
}

// MARK: - UICollectionViewDataSource
extension StoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == storyCollectionView {
            return stories.count
            
        } else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == storyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                StoryDetailCollectionCell.reuseIdentifier, for: indexPath)
            guard let storyCell = cell as? StoryDetailCollectionCell else { return cell }
            
            storyCell.closeButton.addTarget(self, action: #selector(dismissStoryVC(_:)), for: .touchUpInside)
            storyCell.url = URL(string: stories[indexPath.item].videoLink)!
            storyCell.layoutIfNeeded()
            
            return storyCell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCounterCell.reuseIdentifier, for: indexPath)
            guard let counterCell = cell as? StoryCounterCell else { return cell }
            
            return counterCell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension StoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == storyCollectionView {
            return collectionView.frame.size
            
        } else {
            let width = collectionView.frame.size.width / 5 - 1
            return CGSize(width: width, height: 4)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        if collectionView == storyCollectionView {
            guard let storyCell = cell as? StoryDetailCollectionCell else { return }
            storyCell.startPlaying()
        }
    }
}
