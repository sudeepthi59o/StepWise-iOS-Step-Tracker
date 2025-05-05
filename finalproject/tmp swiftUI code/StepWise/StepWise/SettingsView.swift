import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsModel

    var body: some View {
        ZStack {
            // Match HomeView's background
            LinearGradient(gradient: Gradient(colors: [.mint, .cyan]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            List {
                Section(header: Text("Reminders")
                    .foregroundColor(.white)) {
                    Toggle(isOn: $viewModel.toggleOn) {
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
                        TextField("e.g. 5000", value: $viewModel.dailyStepGoal, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }

                    Button(action: {
                        if viewModel.checkIfValidGoal() {
                            print("Goal updated")
                        }
                    }) {
                        Label("Submit Goal", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .listRowBackground(Color.white.opacity(0.2))

                Section(header: Text("Units")
                    .foregroundColor(.white)) {
                    Picker("Preferred Units", selection: $viewModel.selectedUnits) {
                        Text("Kilometers").tag("kms")
                        Text("Miles").tag("miles")
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Button(action: {
                        if viewModel.checkIfValidUnits() {
                            print("Units updated")
                        }
                    }) {
                        Label("Submit Units", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                .listRowBackground(Color.white.opacity(0.2))

                Section {
                    Button(role: .destructive) {
                        viewModel.deleteHistory()
                    } label: {
                        Label("Reset Step History", systemImage: "trash.fill")
                            .foregroundColor(.red)
                    }
                }
                .listRowBackground(Color.white.opacity(0.2))
            }
            .scrollContentBackground(.hidden) // Makes list background transparent
            .navigationTitle("Settings")
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsModel())
    }
}
