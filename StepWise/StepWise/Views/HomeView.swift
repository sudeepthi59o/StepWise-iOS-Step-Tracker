//
//  HomeView.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 05/07/25
//

import SwiftUI

struct HomeView: View {
    @StateObject var stepDataController: StepDataController
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.mint, .cyan]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("StepWise")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .tracking(1)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 3)
                    .padding(.bottom, 10)
                
                Spacer()
                
                VStack(spacing: 30) {
                    MetricRow(icon: "figure.walk", label: "Steps", value: "\(stepDataController.stepCount)")
                    MetricRow(icon: "map.fill", label: "Distance", value: "\(stepDataController.distance)")
                    MetricRow(icon: "flame.fill", label: "Calories", value: String(format: "%.0f cal", stepDataController.calories))
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
                
                HStack(spacing: 20) {
                    ActionButton(title: "Start", icon: "play.fill", color: .green) {
                        stepDataController.startTrackingSteps()
                    }
                    ActionButton(title: "Stop", icon: "stop.fill", color: .red) {
                        stepDataController.stopTrackingSteps()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(stepDataController: StepDataController(context: PersistenceController.shared.container.viewContext))
    }
}
