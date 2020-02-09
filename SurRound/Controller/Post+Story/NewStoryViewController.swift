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
    
    // MARK: - Type Functions
    static func storyboardInstance() -> NewStoryViewController? {
        
        return UIStoryboard.story.instantiateViewController(identifier:
            String(describing: NewStoryViewController.self)) as? NewStoryViewController
    }
    
    // MARK: - Public Properties
    @IBOutlet weak var sendButton: UIButton!
    
    var videoURL: URL?
    var player: AVPlayer?
    
    // MARK: - Private Properties
    private lazy var layer: AVPlayerLayer = {
        self.player = AVPlayer(url: videoURL!)
        let layer = AVPlayerLayer(player: self.player)
        return layer
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.addSublayer(self.layer)
        view.bringSubviewToFront(sendButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layer.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        player?.play()
    }
    
    // MARK: - User Actions
    @IBAction func sendStory(_ sender: UIButton) {
        
        guard let url = videoURL else { return }
        guard let place = PlaceManager.current.place else {
            return
        }
        SRProgressHUD.showLoading(text: "Uploading Video...")
        do {
            try StoryManager().createStory(url, at: place) { result in
                
                SRProgressHUD.dismiss()
                switch result {
                case .success:
                    self.presentingViewController?.dismiss(animated: true, completion: {
                        SRProgressHUD.showSuccess()
                    })
                    
                case .failure(let error):
                    SRProgressHUD.showFailure(text: error.localizedDescription)
                }
            }
        } catch {
            SRProgressHUD.showFailure(text: "Unable to convert file to Data")
        }
    }
}
