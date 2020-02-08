//
//  NewStoryViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/7.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import AVFoundation

class NewStoryViewController: UIViewController {
    
    static func storyboardInstance() -> NewStoryViewController? {
        
        return UIStoryboard.story.instantiateViewController(identifier:
            String(describing: NewStoryViewController.self)) as? NewStoryViewController
    }
    
    var movieURL: URL?
    var player: AVPlayer?
    
    private lazy var layer: AVPlayerLayer = {
        self.player = AVPlayer(url: movieURL!)
        let layer = AVPlayerLayer(player: self.player)
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.addSublayer(self.layer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layer.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        player?.play()
    }
    
    @IBAction func sendStory(_ sender: UIButton) {
        
    }
}
