//
//  NearestListViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/31.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

struct PostWithDistance {
    
    let post: Post
    let distance: Double
    
    init(post: Post, currentCoordinate: Coordinate) {
        self.post = post
        self.distance = PlaceManager.calculateDistance(post.place.coordinate, reference: currentCoordinate)
    }
}

class NearestListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerCellWithNib(withCellClass: PlaceItemListCell.self)
            tableView.separatorStyle = .none
        }
    }
    
    private var data: [PostWithDistance] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
    }
    
    private func fetchData() {
        
        guard let currentCoordinate = PlaceManager.current.coordinate else {
            SRProgressHUD.showFailure(text: "無法取得所在位置")
            return
        }
        
        PostManager.shared.fetchNearestPost(coordinate: currentCoordinate) { [weak self] (result) in
            do {
                let posts = try result.get()
                posts.forEach { post in
                    self?.data.append(.init(post: post, currentCoordinate: currentCoordinate))
                }
            } catch {
                print(error)
            }
        }
    }
}

extension NearestListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: PlaceItemListCell.reuseIdentifier, for: indexPath)
        guard let placeCell = cell as? PlaceItemListCell else { return cell }
        
        let item = data[indexPath.row]
        placeCell.setupCell(item.post, distance: item.distance)
        
        return cell
    }
}

extension NearestListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard
            let nav = UIStoryboard.post.instantiateInitialViewController() as? UINavigationController,
            let postDetailVC = nav.topViewController as? PostContentViewController else { return }
        postDetailVC.post = data[indexPath.row].post
        nav.modalPresentationStyle = .overCurrentContext
        present(nav, animated: true, completion: nil)
    }
}
