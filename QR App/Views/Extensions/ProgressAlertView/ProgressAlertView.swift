//
//  ProgressAlertView.swift
//  SnapTrim PRO
//
//  Created by Touheed khan on 15/04/2025.
//

import UIKit
import NVActivityIndicatorView
import NVActivityIndicatorViewExtended

class ProgressAlertView: UIView {

    @IBOutlet var parentView: UIView! // The main container view
    @IBOutlet weak var alertView: UIView! // The actual alert content view
    static let instance = ProgressAlertView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadViewFromNib()
        self.setupView()
        self.addActivityIndicator()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
       
    }

    private func loadViewFromNib() {
        Bundle.main.loadNibNamed("ProgressAlertView", owner: self, options: nil)
        guard let contentView = parentView else { return }
        contentView.frame = UIScreen.main.bounds
        addSubview(contentView)
    }
    // MARK: - SetupView
    private func setupView() {
        parentView.backgroundColor = .clear // Transparent black background
    }


    
    func show() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first {
            keyWindow.addSubview(self.parentView)
        }
    }

    func dismiss() {
        
        self.parentView.removeFromSuperview()
    }
    
    // MARK: - Add Activity Indicator
    func addActivityIndicator() {
        
        let size = CGSize(width: 60.0, height: 60.0)
        // Calculate the frame to center the indicator in the parent view
        guard let parentView = self.parentView else { return }
        
        let x = (parentView.bounds.width - size.width) / 2
        let y = (parentView.bounds.height - size.height) / 2
        let frame = CGRect(x: x, y: y, width: size.width, height: size.height)

        // Create and configure the activity indicator
        let activityIndicatorView = NVActivityIndicatorView(frame: frame, type: .ballRotate)
        activityIndicatorView.color = #colorLiteral(red: 1, green: 0.3490196078, blue: 0.7058823529, alpha: 0.7036564626) // Customize the color if needed
        activityIndicatorView.startAnimating()
        
        print("activityIndicatorView")

        // Add to the parent view
        self.parentView.addSubview(activityIndicatorView)
    }

}
