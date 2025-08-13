//
//  LogoAnimtions.swift
//  QR App
//
//  Created by MacBook Air on 29/07/2025.
//


import UIKit
import Lottie

class SampleRemoveObjectAnim: UIView {

    private var animationView: LottieAnimationView?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addLottie()
    }

    func addLottie() {
        animationView = LottieAnimationView(name: "data")
        
        // Ensure animationView is not nil
        guard let animationView = animationView else { return }
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 2.0 // Increased speed for faster animation
        
        self.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: self.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
        animationView.play()
    }


}
