//
//  VideoView.swift
//  QR App
//
//  Created by MacBook Air on 29/07/2025.
//

import UIKit
import AVFoundation

class VideoView: UIView {
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVideo()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupVideo()
    }
    
    private func setupVideo() {
        // Replace with your video file name (without extension)
        guard let path = Bundle.main.path(forResource: "interoVideo", ofType: "MP4") else {
            print("Video file not found")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        
        guard let playerLayer = playerLayer else { return }
        playerLayer.frame = bounds
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        
        // Loop the video
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loopVideo),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        
        player?.play()
    }
    
    @objc private func loopVideo() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}

