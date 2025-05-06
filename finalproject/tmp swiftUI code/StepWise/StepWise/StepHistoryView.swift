import SwiftUI
import CoreData
import Charts

struct StepHistoryView: View {
    @ObservedObject var model: StepHistoryModel
    @State private var filter: TimeFilter = .daily
    @State private var refresh: Bool = false
    @State private var showAlert = false

    var chartEntries: [StepHistoryModel.ChartEntry] {
        model.generateChartData(for: filter.toTimePeriod())
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
                        }
                        .chartXAxis {
                            AxisMarks(values: .automatic(desiredCount: 7)) { value in
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

enum TimeFilter: String, CaseIterable, Identifiable {
    case daily = "Day"
    case weekly = "Week"
    case monthly = "Month"

    var id: String { self.rawValue }

    func toTimePeriod() -> StepHistoryModel.TimePeriod {
        switch self {
        case .daily: return .daily
        case .weekly: return .weekly
        case .monthly: return .monthly
        }
    }
}

struct StepHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        StepHistoryView(model: StepHistoryModel(context: PersistenceController.shared.container.viewContext))
    }
}
