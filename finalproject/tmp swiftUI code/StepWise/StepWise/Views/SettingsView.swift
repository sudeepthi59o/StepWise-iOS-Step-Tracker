//
//  SettingsView.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 05/07/25
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsController: SettingsController
    
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
                    Section(header: Text("Reminders")
                        .foregroundColor(.white)) {
                            Toggle(isOn: $settingsController.toggleOn) {
                                Label("Enable Daily Reminder", systemImage: "bell.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.2))
                    
                    Section(header: Text("Step Goal")
                        .foregroundColor(.white)) {
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
                                    .toolbar {
                                            ToolbarItem(placement: .keyboard) {
                                                Button("Done") {
                                                    // Dismiss keyboard when Done is tapped
                                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                                }
                                            }
                                        }
                                
                                
                            }
                            
                            Button(action: {
                                if settingsController.checkIfValidUnits() {
                                    settingsController.submitUnitsIfChanged()
                                }
                            }) {
                                Label("Submit Units", systemImage: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }

                        }
                        .listRowBackground(Color.white.opacity(0.2))
                    
                    Section(header: Text("Units")
                        .foregroundColor(.white)) {
                            Picker("Preferred Units", selection: $settingsController.selectedUnits) {
                                Text("Kilometers").tag("kms")
                                Text("Miles").tag("miles")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            Button(action: {
                                if settingsController.checkIfValidUnits() {
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
                    
                    Section {
                        Button(role: .destructive) {
                            settingsController.deleteHistory()
                        } label: {
                            Label("Reset Step History", systemImage: "trash.fill")
                                .foregroundColor(.red)
                        }
                    }
                    .listRowBackground(Color.white.opacity(0.2))
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settingsController: SettingsController(context: PersistenceController.shared.container.viewContext))
    }
}
