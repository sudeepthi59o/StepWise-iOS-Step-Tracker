//
//  StepHistoryView.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 05/07/25
//

import SwiftUI
import CoreData
import Charts

struct StepHistoryView: View {
@ObservedObject var stepHistoryController: StepHistoryController
@State private var filter: TimeFilter = .daily

var chartEntries: [ChartEntry] {
    stepHistoryController.generateChartData(for: filter.toTimePeriod())
}

var body: some View {
    ZStack {
        LinearGradient(gradient: Gradient(colors: [.mint, .cyan]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .ignoresSafeArea()
        
        VStack(spacing: 20) {
            Text("History")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.top)
            
            Picker("Filter", selection: $filter) {
                ForEach(TimeFilter.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            VStack(spacing: 10) {
                Text("\(filter.rawValue) Total Steps")
                    .foregroundColor(.white.opacity(0.8))
                Text("\(chartEntries.reduce(0) { $0 + $1.stepCount })")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.2))
            .cornerRadius(20)
            .padding(.horizontal)
            
            if chartEntries.isEmpty {
                Text("No data available")
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 100)
            } else {
                Chart {
                    ForEach(chartEntries) { item in
                        BarMark(
                            x: .value("Time", item.label),
                            y: .value("Steps", item.stepCount)
                        )
                        .foregroundStyle(.white)
                        .annotation {
                            Text("\(item.stepCount)")
                                .font(.caption2)
                                .foregroundColor(.white)
                        }
                    }
                }.id(filter)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 6)) { value in
                        AxisValueLabel()
                    }
                }
                .frame(height: 300)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
                .padding(.horizontal)
                
            }
            
            Spacer()
        }
    }
}

}

struct StepHistoryView_Previews: PreviewProvider {
static var previews: some View {
StepHistoryView(stepHistoryController: StepHistoryController(context: PersistenceController.shared.container.viewContext))
}
}
