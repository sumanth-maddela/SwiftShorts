//
//  VideoCollectionViewCell.swift
//  SwiftShorts
//
//  Created by Sumanth Maddela on 23/07/25.
//

import UIKit
import AVFoundation

class VideoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "VideoCollectionViewCell"
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        contentView.addSubview(label)
        contentView.addSubview(muteButton)
        muteButton.addTarget(self, action: #selector(toggleMute), for: .touchUpInside)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let muteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Unmute", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            muteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            muteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
        
    func configure(with videoURLString: String, labelText: String? = nil) {
        label.text = labelText
        playVideo(from: videoURLString)
    }
    
    private func playVideo(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        
        player = AVPlayer(url: url)
        player?.isMuted = false
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = contentView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        
        if let playerLayer = playerLayer {
            contentView.layer.insertSublayer(playerLayer, below: label.layer)
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidReachEnd(_:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        
        player?.play()
    }
    

    @objc private func playerDidReachEnd(_ notification: Notification) {
        player?.seek(to: .zero)
        player?.play()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
        
        NotificationCenter.default.removeObserver(self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = contentView.bounds
    }

    @objc private func toggleMute() {
        guard let player = player else { return }
        player.isMuted.toggle()
        muteButton.setTitle(player.isMuted ? "Unmute" : "Mute", for: .normal)
    }

}
