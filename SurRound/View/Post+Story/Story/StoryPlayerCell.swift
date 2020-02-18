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
    
    func updateCurrentTime(_ cell: StoryPlayerCell, current: Double, duration: Double)
    
    func didEndPlayingVideo(_ cell: StoryPlayerCell)
}

class StoryPlayerCell: UICollectionViewCell {
    
    var url: URL!
    
    weak var delegate: StoryPlayerCellDelegate?
    
    private var player: AVPlayer!
    private var playerItem: AVPlayerItem!
    private var playerLayer: AVPlayerLayer!
    private var timeObserverToken: Any?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleCell()
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
        
    func configurePlayer() {
        
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: self.playerItem)
        playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = contentView.bounds
        contentView.layer.addSublayer(playerLayer)
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
}
