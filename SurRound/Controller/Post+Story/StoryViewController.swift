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
    
    var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    var storyEntities = [StoryEntity]()
    
    var currentSection: Int = 0 {
        didSet { progressBarCollectionView.reloadData() }
    }
    
    private var videoDuration: Double = 0.0
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCollectionViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        storyCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
        currentSection = indexPath.section
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
            to: view.safeAreaLayoutGuide, top: 0, leading: 0, trailing: 0)
        progressBarCollectionView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        progressBarCollectionView.registerCellWithNib(cellWithClass: StoryCounterCell.self)
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
            
            storyCell.closeButton.addTarget(self, action: #selector(dismissStoryVC(_:)), for: .touchUpInside)
            
            storyCell.url = URL(string: storyEntities[indexPath.section].stories[indexPath.item].videoLink)!
            
            storyCell.layoutIfNeeded()
            
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
            let width = (collectionView.frame.size.width - 2) / storyEntities[currentSection].stories.count.cgFloat
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
}

extension StoryViewController: StoryPlayerCellDelegate {
    
//    func didStartPlayingVideo(_ cell: StoryPlayerCell, duration: Double) {
//        print("Start playing with duration: \(duration) seconds")
//        self.videoDuration = duration
//    }
    
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
        print("Did end playing")
//        
//        guard let indexPath = storyCollectionView.indexPath(for: cell) else { return }
//        let sectionItems = storyCollectionView.numberOfItems(inSection: indexPath.section)
//        
//        let nextIndexPath: IndexPath
//        if indexPath.item == (sectionItems - 1) {
//            nextIndexPath = IndexPath(item: 0, section: indexPath.section + 1)
//        } else {
//            nextIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
//        }
//        
//        storyCollectionView.scrollToItem(at: nextIndexPath, at: .top, animated: false)
    }
}
