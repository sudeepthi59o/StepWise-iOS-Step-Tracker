//
//  StepDataModel.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 05/07/25
//

import Foundation

class StepDataModel {
    
    static func calculateDistance(steps: Int) -> Double {
        return Double(steps) * 0.000762 // 0.000762 km per step
    }
    
    static func calculateCalories(steps: Int) -> Double {
        return Double(steps) * 0.04 // 0.04 calories per step
    }
}
