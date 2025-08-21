//
//  ViewAnalysisVC.swift
//  QR App
//
//  Created by Touheed khan on 20/08/2025.
//

import UIKit
import DGCharts

class ViewAnalysisVC: UIViewController {
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var acceptedProgresBar: UIProgressView!
    @IBOutlet weak var scannedProgressBar: UIProgressView!
    @IBOutlet weak var pendingProgressBar: UIProgressView!
    @IBOutlet weak var rejectedProgressBar: UIProgressView!
    @IBOutlet weak var acceptedCounterlbl: UILabel!
    @IBOutlet weak var scannedCounterlbl: UILabel!
    @IBOutlet weak var pendingCounterlbl: UILabel!
    @IBOutlet weak var rejectedcounterlbl: UILabel!
    
    var progressAlert = ProgressAlertView()
    
    var totalPending = 0
    var totalRejected = 0
    var totalAccpted = 0
    var totalScannned = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPieChart()
        
        DispatchQueue.main.async {
            
          
            self.progressAlert.show()
            self.getTotalCards()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleReloadNotification), name: .reloadViewAnalysisData, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Apply custom styling to all progress bars
        styleProgressBar(acceptedProgresBar, height: 10, color: .systemGreen)
        styleProgressBar(rejectedProgressBar, height: 10, color: .systemRed)
        styleProgressBar(pendingProgressBar, height: 10, color: .systemYellow)
        styleProgressBar(scannedProgressBar, height: 10, color: UIColor.systemBlue)
    }
    
    
    @objc func handleReloadNotification() {
        print("🔁 handleReloadNotification triggered")
        DispatchQueue.main.async {
            self.progressAlert.show()
            self.getTotalCards()
        }
    }
    
    
    // MARK: - Firebase Cards Count
    func getTotalCards() {
        if let ownerID = UserModel.shared?.userId {
            FirebaseManager.shared.checkOwnerIdOccurrences(ownerId: ownerID) { result in
                switch result {
                case .success(let counts):
                    let businessCount = counts["UserBusinessCard"] ?? 0
                    let invitationCount = counts["UserInvitationCard"] ?? 0
                    let totalCards = businessCount + invitationCount
                    
                    print("Business Cards found: \(businessCount)")
                    print("Invitation Cards found: \(invitationCount)")
                    print("Total Cards found: \(totalCards)")
                    
                    self.pieChart.centerText = "Cards\n\(totalCards)"
                    self.checkOwnerIdInAcceptedAndScanned()
                    
                case .failure(let error):
                    self.progressAlert.dismiss()
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    // MARK: - Firebase Accepted & Scanned
    func checkOwnerIdInAcceptedAndScanned() {
        if let ownerID = UserModel.shared?.userId {
            FirebaseManager.shared.checkOwnerIdInAcceptedAndScanned(ownerId: ownerID) { accepted, scanned in
                print("✅ Accepted Matches: \(accepted)")
                print("✅ Scanned Matches: \(scanned)")
                
                self.totalAccpted = accepted
                self.totalScannned = scanned
                
                DispatchQueue.main.async {
                    let acceptedPercentage = min(Float(accepted) * 10, 100)
                    let scannedPercentage  = min(Float(scanned) * 10, 100)
                    
                    self.checkPending()
                    
                    // Progress bars
                    self.acceptedProgresBar.progress = acceptedPercentage / 100.0
                    self.acceptedCounterlbl.text = "Avg \(accepted)"
                    
                    self.scannedProgressBar.progress = scannedPercentage / 100.0
                    self.scannedCounterlbl.text = "Avg \(scanned)"
                    
                    // For now rejected = 0 (you can later replace with Firebase query)
                    self.totalRejected = 0
                    self.rejectedProgressBar.progress = 0.0
                    self.rejectedcounterlbl.text = "Avg 0"
                }
                
                self.progressAlert.dismiss()
            }
        }
    }
    
    
    // MARK: - Firebase Pending
    func checkPending() {
        FirebaseManager.shared.checkPendingStatus() { pending in
            self.totalPending = pending
            
            DispatchQueue.main.async {
                let pendingPercentage = min(Float(pending) * 10, 100)
                
                self.pendingCounterlbl.text = "Avg \(pending)"
                self.pendingProgressBar.progress = pendingPercentage / 100.0
            }
            
            // 🔄 Update chart every time we refresh values
            self.updatePieChart()
        }
    }
    
    
    // MARK: - Progress Bar Styling
    private func styleProgressBar(_ bar: UIProgressView, height: CGFloat, color: UIColor) {
        bar.transform = CGAffineTransform(scaleX: 1, y: height / bar.frame.height)
        bar.layer.cornerRadius = height / 2
        bar.clipsToBounds = true
        
        if let progressLayer = bar.layer.sublayers?.first {
            progressLayer.cornerRadius = height / 2
            progressLayer.masksToBounds = true
        }
        
        bar.progressTintColor = color
        bar.trackTintColor = #colorLiteral(red: 0.8277246356, green: 0.8240846992, blue: 0.8499574065, alpha: 1)
    }
    
    
    // MARK: - Setup PieChart
    private func setupPieChart() {
        pieChart.centerTextRadiusPercent = 0.95
        pieChart.holeRadiusPercent = 0.6
        pieChart.transparentCircleRadiusPercent = 0.65

    }
    
    
    // MARK: - Update Pie Chart with Firebase Data
    // MARK: - Update Pie Chart with Firebase Data
    private func updatePieChart() {
        let entries = [
            PieChartDataEntry(value: Double(totalAccpted), label: "Accepted"),
            PieChartDataEntry(value: Double(totalRejected), label: "Rejected"),
            PieChartDataEntry(value: Double(totalPending), label: "Pending"),
            PieChartDataEntry(value: Double(totalScannned), label: "Scanned")
        ]
        
        let dataSet = PieChartDataSet(entries: entries, label: "Status")
        dataSet.colors = [
            UIColor.systemGreen,   // Accepted
            UIColor.systemRed,     // Rejected
            UIColor.systemYellow,  // Pending
            UIColor.systemBlue     // Scanned
        ]
        
        dataSet.valueFont = .systemFont(ofSize: 12, weight: .bold)
        dataSet.valueTextColor = .clear
        
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        
        // 🎯 Animate with a round rotation
        pieChart.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }

}

