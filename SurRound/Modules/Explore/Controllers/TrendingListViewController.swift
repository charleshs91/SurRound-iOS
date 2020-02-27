//
//  TrendingListViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/31.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import collection_view_layouts

class TrendingListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.registerCellWithNib(cellWithClass: TrendingListGridCell.self)
            collectionView.collectionViewLayout = getLayout()
            collectionView.addHeaderRefreshing { [weak self] in
                self?.fetchData()
            }
        }
    }
    
    private var posts: [Post] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    // MARK: - Private Methods
    private func getLayout() -> UICollectionViewLayout {
        
        let layout = InstagramLayout()
        layout.delegate = self
        layout.contentPadding = ItemsPadding(horizontal: 4, vertical: 4)
        layout.cellsPadding = ItemsPadding(horizontal: 4, vertical: 4)
        layout.gridType = .regularPreviewCell
        return layout
    }
    
    private func fetchData() {
        
        PostManager.shared.fetchTrendingPost { [weak self] (result) in
            
            self?.collectionView.endHeaderRefreshing()
            
            switch result {
            case .success(let posts):
                self?.posts = posts
                
            case .failure(let error):
                SRProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension TrendingListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrendingListGridCell.reuseIdentifier, for: indexPath)
        
        guard let gridCell = cell as? TrendingListGridCell else {
            return cell
            
        }
        gridCell.postImageView.loadImage(posts[indexPath.item].mediaLink)
        
        return gridCell
    }
}

// MARK: - UICollectionViewDelegate
extension TrendingListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard
            let nav = UIStoryboard.post.instantiateInitialViewController() as? UINavigationController,
            let postDetailVC = nav.topViewController as? PostContentViewController else { return }
        postDetailVC.post = posts[indexPath.row]
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
}

// MARK: - LayoutDelegate
extension TrendingListViewController: LayoutDelegate {
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 200)
    }
}
