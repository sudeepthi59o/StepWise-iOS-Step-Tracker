import SwiftUI

struct HomeView: View {
    @StateObject var stepDataModel: StepDataModel

    var body: some View {
        ZStack {
            // Elegant dark-toned gradient background
            LinearGradient(gradient: Gradient(colors: [.mint, .cyan]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                            .ignoresSafeArea()
            
            VStack {
                Spacer()

                // App title with rounded, bouncy feel
                Text("StepWise")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .tracking(1)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 3)
                    .padding(.bottom, 10)

                Spacer()

                // Metric display card
                VStack(spacing: 30) {
                    MetricRow(icon: "figure.walk", label: "Steps", value: "\(stepDataModel.stepCount)")
                    MetricRow(icon: "map.fill", label: "Distance", value: String(format: "%.2f km", stepDataModel.distance))
                    MetricRow(icon: "flame.fill", label: "Calories", value: String(format: "%.0f cal", stepDataModel.calories))
                }
                .padding(35)
                .frame(maxWidth: .infinity)
                .background(
                    Color.white.opacity(0.2)
                        .blur(radius: 0)
                )
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                .padding(.horizontal)

                Spacer()

                // Control buttons
                HStack(spacing: 20) {
                    ActionButton(title: "Start", icon: "play.fill", color: .green) {
                        stepDataModel.startTrackingSteps()
                    }
                    ActionButton(title: "Stop", icon: "stop.fill", color: .red) {
                        stepDataModel.stopTrackingSteps()
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
        }
    }
}

// Reusable metric display row
struct MetricRow: View {
    let icon: String
    let label: String
    let value: String

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
                Text(value)
                    .font(.title3.bold())
                    .foregroundColor(.white)
            }
            Spacer()
        }
    }
}

// Reusable rounded button
struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.9))
            .foregroundColor(.white)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(stepDataModel: StepDataModel(context: PersistenceController.shared.container.viewContext))
    }
}
