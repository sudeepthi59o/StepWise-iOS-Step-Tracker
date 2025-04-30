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
    
    
    @IBAction func getDailyHistoryButton(_ sender: Any) {
        //TODO
    }
    
    @IBAction func getWeeklyHistoryButton(_ sender: Any) {
        //TODO

    }
    
    @IBAction func getMonthlyHistoryButton(_ sender: Any) {
        //TODO
    }
    
    override func viewDidLoad() {
        
        self.stepHistoryLabel.text="History"


        // Do any additional setup after loading the view.
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
