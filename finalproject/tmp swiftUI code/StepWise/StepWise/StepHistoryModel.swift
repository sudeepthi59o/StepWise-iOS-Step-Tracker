//import Foundation
//import CoreData
//
//@MainActor
//class StepHistoryModel: ObservableObject {
//    
//    private let context: NSManagedObjectContext
//    private let calendar = Calendar.current
//    private let formatter: DateFormatter
//
//    init(context: NSManagedObjectContext) {
//        self.context = context
//        self.formatter = DateFormatter()
//    }
//
//    enum TimePeriod {
//        case daily
//        case weekly
//        case monthly
//    }
//
//    struct ChartEntry: Identifiable {
//        let id = UUID()
//        let label: String
//        let stepCount: Int
//    }
//
//    func generateChartData(for period: TimePeriod) -> [ChartEntry] {
//        let entries = fetchStepData(for: period)
//
//        switch period {
//        case .daily:
//            let total = entries.reduce(0) { $0 + Int($1.stepCount) }
//            return [ChartEntry(label: "Today", stepCount: total)]
//
//        case .weekly:
//            formatter.dateFormat = "EEE" // Mon, Tue, etc.
//            let grouped = Dictionary(grouping: entries) {
//                calendar.startOfDay(for: $0.date ?? Date())
//            }
//
//            return grouped.sorted { $0.key < $1.key }.map { (date, group) in
//                let label = formatter.string(from: date)
//                let total = group.reduce(0) { $0 + Int($1.stepCount) }
//                return ChartEntry(label: label, stepCount: total)
//            }
//
//        case .monthly:
//            formatter.dateFormat = "MMM d" // Jan 1, Jan 2...
//            let grouped = Dictionary(grouping: entries) {
//                calendar.startOfDay(for: $0.date ?? Date())
//            }
//
//            return grouped.sorted { $0.key < $1.key }.map { (date, group) in
//                let label = formatter.string(from: date)
//                let total = group.reduce(0) { $0 + Int($1.stepCount) }
//                return ChartEntry(label: label, stepCount: total)
//            }
//        }
//    }
//
//    private func fetchStepData(for period: TimePeriod) -> [StepDataEntry] {
//            let fetchRequest: NSFetchRequest<StepDataEntry> = StepDataEntry.fetchRequest()
//            let now = Date()
//
//            switch period {
//            case .daily:
//                let start = calendar.startOfDay(for: now)
//                let end = calendar.date(byAdding: .day, value: 1, to: start)!
//                fetchRequest.predicate = NSPredicate(format: "timestamp >= %@ AND timestamp < %@", start as NSDate, end as NSDate)
//
//            case .weekly:
//                let start = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now))!
//                let end = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now))!
//                fetchRequest.predicate = NSPredicate(format: "timestamp >= %@ AND timestamp < %@", start as NSDate, end as NSDate)
//
//            case .monthly:
//                let start = calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: now))!
//                let end = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now))!
//                fetchRequest.predicate = NSPredicate(format: "timestamp >= %@ AND timestamp < %@", start as NSDate, end as NSDate)
//            }
//
//            do {
//                return try context.fetch(fetchRequest)
//            } catch {
//                print("Fetch failed: \(error)")
//                return []
//            }
//        }
//    }
