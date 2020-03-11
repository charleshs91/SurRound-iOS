//
//  StoryViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/7.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class StoryViewController: SRBaseViewController {

    var storyEntities: [StoryCollection] = []
    
    var initialIndexPath: IndexPath! {
        didSet {
            currentSection = initialIndexPath.section
        }
    }

    var currentSection: Int = 0 {
        didSet {
            if currentSection != oldValue {
                progressBarCollectionView.reloadData()
                updateHeaderInfo(index: currentSection)
            }
        }
    }
    
    private var onShowUpFlag: Bool = true
    
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

    private let userPicture: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let datetimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray5
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private lazy var headerInfoStackView: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [usernameLabel, UIView(), datetimeLabel])
        vStack.axis = .vertical
        vStack.distribution = .fill
        return vStack
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateHeaderInfo(index: currentSection)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startPlayerCellAt(indexPath: initialIndexPath)
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
    private func setupViews() {
        
        view.backgroundColor = .black

        setupCollectionViews()
        setupCloseButton()
        setupHeaderInfoViews()
    }
    
    private func setupCollectionViews() {
        
        storyCollectionView.dataSource = self
        storyCollectionView.delegate = self
        storyCollectionView.stickToSafeArea(view)
        storyCollectionView.registerCellWithNib(cellWithClass: StoryPlayerCell.self)
        
        view.addSubview(progressBarCollectionView)
        progressBarCollectionView.dataSource = self
        progressBarCollectionView.delegate = self
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
    
    private func setupHeaderInfoViews() {
        
        let imageWidth: CGFloat = 40
        view.addSubview(userPicture)
        userPicture.anchor(top: progressBarCollectionView.bottomAnchor,
                           leading: view.safeAreaLayoutGuide.leadingAnchor,
                           bottom: nil, trailing: nil,
                           padding: .init(top: 8, left: 16, bottom: 0, right: 0),
                           widthConstant: imageWidth, heightConstant: imageWidth)
        userPicture.layer.cornerRadius = imageWidth / 2
        
        view.addSubview(headerInfoStackView)
        headerInfoStackView.anchor(top: userPicture.topAnchor,
                                   leading: userPicture.trailingAnchor,
                                   bottom: userPicture.bottomAnchor,
                                   trailing: closeButton.leadingAnchor,
                                   padding: .init(top: 0, left: 8, bottom: 0, right: 8),
                                   widthConstant: 0, heightConstant: 0)
    }
    
    private func updateHeaderInfo(index: Int) {
        
        let user = storyEntities[index]
        userPicture.loadImage(user.author.avatar)
        usernameLabel.text = user.author.username
    }
    
    private func startPlayerCellAt(indexPath: IndexPath) {
        
        if let playerCell = storyCollectionView.cellForItem(at: indexPath) as? StoryPlayerCell {
            playerCell.startPlaying(updateFrequency: 0.1)
            currentSection = indexPath.section
        }
    }
    
    private func stopPlayerCellAt(indexPath: IndexPath) {
        
        if let playerCell = storyCollectionView.cellForItem(at: indexPath) as? StoryPlayerCell {
            playerCell.stopPlaying()
            currentSection = indexPath.section
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension StoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            
            let url = URL(string: storyEntities[indexPath.section].stories[indexPath.item].videoLink)!
            storyCell.configurePlayer(for: url)
            storyCell.delegate = self
            return storyCell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                StoryCounterCell.reuseIdentifier, for: indexPath)
            guard let counterCell = cell as? StoryCounterCell else { return cell }
            
            counterCell.timerBar.progress = 0
            return counterCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        if collectionView == storyCollectionView && onShowUpFlag {
            storyCollectionView.scrollToItem(at: initialIndexPath, at: .left, animated: false)
            onShowUpFlag = false
        }
    }
    
    // MARK: - sizeForItemAt
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
    
    // MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        let point = CGPoint(x: scrollView.contentOffset.x + 100, y: 0)
        
        guard
            let collectionView = scrollView as? UICollectionView,
            collectionView == storyCollectionView,
            let indexPath = collectionView.indexPathForItem(at: point) else {
                return
        }
        stopPlayerCellAt(indexPath: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let point = CGPoint(x: scrollView.contentOffset.x + 100, y: 0)
        
        guard
            let collectionView = scrollView as? UICollectionView,
            collectionView == storyCollectionView,
            let indexPath = collectionView.indexPathForItem(at: point) else {
                return
        }
        if let previousProgressCell = progressBarCollectionView.cellForItem(at:
            IndexPath(item: indexPath.item - 1, section: 0)) as? StoryCounterCell {
            previousProgressCell.timerBar.progress = 1
        }
        if let nextProgressCell = progressBarCollectionView.cellForItem(at:
            IndexPath(item: indexPath.item + 1, section: 0)) as? StoryCounterCell {
            nextProgressCell.timerBar.progress = 0
        }
        startPlayerCellAt(indexPath: indexPath)
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
            startPlayerCellAt(indexPath: nextIndexPath)
            
        case (false, false), (false, true):
            let nextIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
            storyCollectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
            startPlayerCellAt(indexPath: nextIndexPath)
        }
    }
}
