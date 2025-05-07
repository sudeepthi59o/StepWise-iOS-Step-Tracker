//
//  SettingsView.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 05/07/25
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsController: SettingsController
    @FocusState private var isStepGoalFocused: Bool
    
    @State private var showInvalidGoalAlert = false

    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.mint, .cyan]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Text("Settings")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                List {
                    remindersSection
                    stepGoalSection
                    unitsSection
                    resetSection
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Settings")
                .listStyle(InsetGroupedListStyle())
            }
            
            if let message = settingsController.notificationStatusMessage {
                VStack {
                    Spacer()
                    Text(message)
                        .font(.subheadline)
                        .padding()
                        .background(Color.black.opacity(0.75))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.bottom, 40)
                        .transition(.opacity)
                        .animation(.easeInOut, value: settingsController.notificationStatusMessage)
                }
            }
        }
    }

    // MARK: - Subviews
    
    private var remindersSection: some View {
        Section(header: Text("Reminders").foregroundColor(.white)) {
            Toggle(isOn: $settingsController.toggleOn) {
                Label("Enable Daily Reminder", systemImage: "bell.fill")
                    .foregroundColor(.white)
            }
        }
        .listRowBackground(Color.white.opacity(0.2))
    }
    
    private var stepGoalSection: some View {
        Section(header: Text("Step Goal").foregroundColor(.white)) {
            HStack {
                Text("Daily Step Goal:")
                    .foregroundColor(.white)
                Spacer()
                TextField("e.g. 5000", value: $settingsController.dailyStepGoal, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 80)
                    .padding(6)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .focused($isStepGoalFocused)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                isStepGoalFocused = false
                            }
                        }
                    }
            }
            
            Button(action: {
                if settingsController.checkIfValidGoal() {
                    settingsController.submitGoal()
                    settingsController.notificationStatusMessage = "Goal updated successfully!"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        settingsController.notificationStatusMessage = nil
                    }
                }else{
                    showInvalidGoalAlert = true
                }
            }) {
                Label("Submit Goal", systemImage: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
            .alert("Invalid Step Goal", isPresented: $showInvalidGoalAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Step goal too high. Please enter a value between 1,000 and 15,000.")
            }
        }
        .listRowBackground(Color.white.opacity(0.2))
    }

    private var unitsSection: some View {
        Section(header: Text("Units").foregroundColor(.white)) {
            Picker("Preferred Units", selection: $settingsController.selectedUnits) {
                Text("Kilometers").tag("kms")
                Text("Miles").tag("miles")
            }
            .pickerStyle(SegmentedPickerStyle())

            Button(action: {
                if settingsController.checkIfValidUnits() {
                    settingsController.submitUnitsIfChanged()
                    settingsController.notificationStatusMessage = "Units updated successfully!"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        settingsController.notificationStatusMessage = nil
                    }
                }
            }) {
                Label("Submit Units", systemImage: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .listRowBackground(Color.white.opacity(0.2))
    }

    private var resetSection: some View {
        Section {
            Button(role: .destructive) {
                settingsController.deleteHistory()
                settingsController.notificationStatusMessage = "Reset History successfully!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    settingsController.notificationStatusMessage = nil
                }
            } label: {
                Label("Reset Step History", systemImage: "trash.fill")
                    .foregroundColor(.red)
            }
        }
        .listRowBackground(Color.white.opacity(0.2))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settingsController: SettingsController(context: PersistenceController.shared.container.viewContext))
    }
}

