//
//  TimeFilter.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 05/07/25
//

import Foundation

enum TimeFilter: String, CaseIterable, Identifiable {
    case daily = "Day"
    case weekly = "Week"
    case monthly = "Month"

    var id: String { self.rawValue }

    func toTimePeriod() -> TimePeriod {
        switch self {
        case .daily: return .daily
        case .weekly: return .weekly
        case .monthly: return .monthly
        }
    }
}
