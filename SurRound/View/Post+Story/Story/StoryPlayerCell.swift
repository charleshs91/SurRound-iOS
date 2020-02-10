//
//  StoryDetailCollectionCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/9.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import AVFoundation

protocol StoryPlayerCellDelegate: AnyObject {
    
//    func didStartPlayingVideo(_ cell: StoryPlayerCell, duration: Double)
    
    func updateCurrentTime(_ cell: StoryPlayerCell, current: Double, duration: Double)
    
    func didEndPlayingVideo(_ cell: StoryPlayerCell)
}

class StoryPlayerCell: UICollectionViewCell {
    
    lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemGray3
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("X", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        return btn
    }()
    
    var url: URL!
    
    weak var delegate: StoryPlayerCellDelegate?
    
    private var player: AVPlayer!
    private var playerItem: AVPlayerItem!
    private var playerLayer: AVPlayerLayer!
    private var timeObserverToken: Any?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleCell()
        setupCloseButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        closeButton.roundToHeight()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        removeTimeObserver()
        
        player = nil
        
        playerItem = nil
        
        playerLayer.removeFromSuperlayer()
        playerLayer = nil
    }
    
    func startPlaying(updateFrequency: Double) {
        
        configurePlayer()
        
        player.play()
        
        timeObserverToken = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: updateFrequency, preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
            queue: DispatchQueue.main
        ) { [weak self] time in
            
            guard let self = self else { return }
            
            self.delegate?.updateCurrentTime(self, current: time.seconds, duration: self.playerItem.duration.seconds)
            
            if time >= self.playerItem.duration {
                self.delegate?.didEndPlayingVideo(self)
            }
        }
    }
        
    private func configurePlayer() {
        
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: self.playerItem)
        playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = contentView.bounds
        contentView.layer.insertSublayer(playerLayer, below: closeButton.layer)
    }
    
    private func removeTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    private func styleCell() {
        
        contentView.backgroundColor = .black
    }
    
    private func setupCloseButton() {
        
        contentView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
