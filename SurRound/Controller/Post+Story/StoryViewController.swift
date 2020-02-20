//
//  StoryViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/7.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {
    
    var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    var storyEntities = [StoryCollection]()
    
    var currentSection: Int = 0 {
        didSet { progressBarCollectionView.reloadData() }
    }
    
    private lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemGray3
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("X", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        btn.addTarget(self, action: #selector(dismissStoryVC(_:)), for: .touchUpInside)
        return btn
    }()
    
    private let progressBarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
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
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupCollectionViews()
        setupCloseButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        storyCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
        currentSection = indexPath.section
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        closeButton.roundToHalfHeight()
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
        storyCollectionView.registerCellWithNib(cellWithClass: StoryPlayerCell.self)
        
        progressBarCollectionView.dataSource = self
        progressBarCollectionView.delegate = self
        view.addSubview(progressBarCollectionView)
        progressBarCollectionView.setConstraints(
            to: view.safeAreaLayoutGuide, top: 4, leading: 0, trailing: 0)
        progressBarCollectionView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        progressBarCollectionView.registerCellWithNib(cellWithClass: StoryCounterCell.self)
    }
    
    private func setupCloseButton() {
        
        view.addSubview(closeButton)
        closeButton.setConstraints(to: view.safeAreaLayoutGuide,
                                   top: 18, leading: nil, trailing: -12, bottom: nil)
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

// MARK: - UICollectionViewDataSource
extension StoryViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if collectionView == storyCollectionView {
            return storyEntities.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == storyCollectionView {
            return storyEntities[section].stories.count
            
        } else {
            return storyEntities[currentSection].stories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == storyCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                StoryPlayerCell.reuseIdentifier, for: indexPath)
            guard let storyCell = cell as? StoryPlayerCell else { return cell }
            
            storyCell.url = URL(string: storyEntities[indexPath.section].stories[indexPath.item].videoLink)!
            storyCell.configurePlayer()
            return storyCell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCounterCell.reuseIdentifier, for: indexPath)
            guard let counterCell = cell as? StoryCounterCell else { return cell }
            
            counterCell.timerBar.progress = 0
            
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
            let counts = storyEntities[currentSection].stories.count.cgFloat
            let width = (collectionView.frame.size.width - 2) / counts
            return CGSize(width: width, height: 4)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        if collectionView == storyCollectionView {
            guard let storyCell = cell as? StoryPlayerCell else { return }
            storyCell.delegate = self
            storyCell.startPlaying(updateFrequency: 0.1)
            
            if currentSection != indexPath.section {
                currentSection = indexPath.section
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {

    }
}

extension StoryViewController: StoryPlayerCellDelegate {
    
    func updateCurrentTime(_ cell: StoryPlayerCell, current: Double, duration: Double) {
        guard
            let indexPath = storyCollectionView.indexPath(for: cell),
            let counterCell = progressBarCollectionView.cellForItem(at: IndexPath(item: indexPath.item, section: 0)) as? StoryCounterCell else { return }
        
        let percentage = current / duration
        if !percentage.isNaN {
            counterCell.timerBar.progress = Float(percentage)
        }
    }
    
    func didEndPlayingVideo(_ cell: StoryPlayerCell) {
        
        guard let indexPath = storyCollectionView.indexPath(for: cell) else { return }
        
        let itemsInSection = storyCollectionView.numberOfItems(inSection: indexPath.section)
        let sections = numberOfSections(in: storyCollectionView)
        
        let isLastItemInSection = indexPath.item == (itemsInSection - 1)
        let isLastSection = indexPath.section == (sections - 1)
        
        switch (isLastItemInSection, isLastSection) {
            
        case (true, true):
            presentingViewController?.dismiss(animated: true, completion: nil)
            
        case (true, false):
            let nextIndexPath = IndexPath(item: 0, section: indexPath.section + 1)
            storyCollectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)

        case (false, false), (false, true):
            let nextIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
            storyCollectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
        }
    }
}
