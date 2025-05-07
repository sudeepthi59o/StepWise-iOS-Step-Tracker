//
//  MetricRow.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 05/07/25
//

import SwiftUI

struct MetricRow: View {
    let icon: String
    let label: String
    let value: String
    
    @AppStorage("selectedUnits") private var selectedUnits: String = "kms"
    
    private func convertToMiles(kilometers: Double) -> Double {
        return kilometers * 0.621371
    }
    
    private func formattedValue() -> String {
        let doubleValue = Double(self.value) ?? 0.0
        if self.selectedUnits == "miles" {
            let miles = convertToMiles(kilometers: doubleValue)
            return String(format: "%.2f miles", miles)
        } else {
            return String(format: "%.2f km", doubleValue)
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text(label.lowercased().contains("distance") ? formattedValue() : value)
                    .font(.title3.bold())
                    .foregroundColor(.white)
            }
            Spacer()
        }
    }
}
