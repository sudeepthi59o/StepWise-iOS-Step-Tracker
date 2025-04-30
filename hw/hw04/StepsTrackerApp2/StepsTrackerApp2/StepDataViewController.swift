//
//  StepDataViewController.swift
//  StepsTrackerApp
//
//  Created by Sudeepthi Rebbalapalli on 4/27/25.
//

import UIKit
import CoreMotion
import CoreData

class StepDataViewController: UIViewController {
    
    var stepDataModel = StepDataModel()
    
    @IBOutlet weak var stepCounterLabel: UILabel!
    @IBOutlet weak var numOfStepsLabel: UILabel!
    @IBOutlet weak var kmsWalkedLabel: UILabel!
    @IBOutlet weak var caloriesBurntLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    @IBAction func onStartButtonClick(_ sender: Any) {
        
        print("startButton tapped")
        
        self.numOfStepsLabel.text = "0"
        self.kmsWalkedLabel.text = "0.00 km"
        self.caloriesBurntLabel.text = "0.00 cal"
        
        self.stepDataModel.startTrackingSteps(onUpdate: { [weak self] steps, distance, calories in
            DispatchQueue.main.async {
                self?.numOfStepsLabel.text = "\(steps)"
                self?.kmsWalkedLabel.text = String(format: "%.2f km", distance)
                self?.caloriesBurntLabel.text = String(format: "%.2f cal", calories)
            }
        }, onError: { error in
            print("Pedometer error: \(error.localizedDescription)")
        })
    }
    
    
    @IBAction func onStopButtonClick(_ sender: Any) {
        
        print("stopButton tapped")
        
        let stepText = self.numOfStepsLabel.text ?? "0"
        
        self.stepDataModel.stopTrackingSteps(stepLabelText: stepText) { steps, distance, calories in
            DispatchQueue.main.async {
                self.kmsWalkedLabel.text = String(format: "%.2f km", distance)
                self.caloriesBurntLabel.text = String(format: "%.2f cal", calories)
                print("Stopping task with steps: \(steps), distance: \(distance), calories: \(calories)")
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Round steps label (if desired)
        numOfStepsLabel.layer.cornerRadius = numOfStepsLabel.frame.height / 2
        numOfStepsLabel.clipsToBounds = true
        
        // Make Start button circular
        startButton.layer.cornerRadius = startButton.frame.size.width / 2
        startButton.clipsToBounds = true
        startButton.backgroundColor = UIColor.systemGreen
        startButton.setTitleColor(.white, for: .normal)
        
        // Make Stop button circular
        stopButton.layer.cornerRadius = stopButton.frame.size.width / 2
        stopButton.clipsToBounds = true
        stopButton.backgroundColor = UIColor.systemRed
        stopButton.setTitleColor(.white, for: .normal)
    }
    
    
    
    
    override func viewDidLoad() {
        
        self.stepCounterLabel.text="Stepwise"
        self.stepDataModel.isStepCountingAvailable()
        
    }
    
    }
    
    
