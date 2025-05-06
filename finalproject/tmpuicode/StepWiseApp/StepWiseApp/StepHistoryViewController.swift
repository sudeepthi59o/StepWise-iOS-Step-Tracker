//
//  StepHistoryViewController.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 04/30/25
//
//

import UIKit

class StepHistoryViewController: UIViewController {
    
    
    @IBOutlet weak var stepHistoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var stepCountLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var kmsWalkedLabel: UILabel!
       
    let historyModel = StepHistoryModel()
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
//        insertManualStepData();
            stepHistoryLabel.text = "History"
        let dailyEntries = historyModel.fetchDailyStepData()
            updateUI(with: dailyEntries, title: "Today")
        }

        @IBAction func getDailyHistoryButton(_ sender: Any) {
            let entries = historyModel.fetchDailyStepData()
            updateUI(with: entries, title: "Today")
        }

        @IBAction func getWeeklyHistoryButton(_ sender: Any) {
            let entries = historyModel.fetchWeeklyStepData()
            updateUI(with: entries, title: "This Week")
        }

        @IBAction func getMonthlyHistoryButton(_ sender: Any) {
            let entries = historyModel.fetchMonthlyData()
            updateUI(with: entries, title: "This Month")
        }

        private func updateUI(with entries: [UserStepEntry], title: String) {
            let totalSteps = entries.reduce(0) { $0 + Int($1.stepCount) }
            let totalCalories = entries.reduce(0) { $0 + $1.calories }
            let totalKms = entries.reduce(0) { $0 + $1.kmsWalked }

            stepHistoryLabel.text = "\(title)'s Summary"
            dateLabel.text = "Entries: \(entries.count)"
            stepCountLabel.text = "Steps: \(totalSteps)"
            caloriesLabel.text = String(format: "Calories: %.2f", totalCalories)
            kmsWalkedLabel.text = String(format: "Kms Walked: %.2f", totalKms)
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
