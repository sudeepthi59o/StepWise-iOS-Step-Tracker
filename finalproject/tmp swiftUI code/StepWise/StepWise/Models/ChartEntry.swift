//
//  ChartEntry.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 05/07/25
//

import Foundation

struct ChartEntry: Identifiable {
    let id = UUID()
    let label: String
    let stepCount: Int
}
