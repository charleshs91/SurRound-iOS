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
    
    private var url: URL!
    
    weak var delegate: StoryPlayerCellDelegate?
    
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var playerLayer = AVPlayerLayer()
    private var timeObserverToken: Any?
    
    private let padding = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        removeTimeObserver()
    }
    
    func startPlaying(updateFrequency: Double) {
        
        guard let player = self.player, let playerItem = self.playerItem else {
            return
        }
        player.seek(to: .zero)
        player.play()

        timeObserverToken = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: updateFrequency, preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
            queue: DispatchQueue.main
        ) { [weak self] time in
            
            guard let strongSelf = self else { return }
            
            strongSelf.delegate?.updateCurrentTime(strongSelf, current: time.seconds, duration: playerItem.duration.seconds)
            
            if time >= playerItem.duration {
                strongSelf.removeTimeObserver()
                strongSelf.delegate?.didEndPlayingVideo(strongSelf)
            }
        }
    }
    
    func stopPlaying() {
        
        player?.pause()
        removeTimeObserver()
    }
        
    func configurePlayer(for url: URL) {
        
        self.url = url
        prepareToPlay()
        setupPlayerLayer()
    }
    
    private func removeTimeObserver() {
        
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    private func prepareToPlay() {
        
        let asset = AVAsset(url: url)
        let assetKeys = ["playable", "hasProtectedContent"]
        playerItem =  AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetKeys)
        player = AVPlayer(playerItem: playerItem)
    }
    
    private func setupPlayerLayer() {
        
        playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.videoGravity = .resizeAspectFill
        contentView.layer.addSublayer(playerLayer)
    }
    
    private func styleCell() {
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = .black
    }
}
