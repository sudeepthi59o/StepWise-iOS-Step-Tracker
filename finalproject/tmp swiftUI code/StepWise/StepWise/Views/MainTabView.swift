//
//  MainTabView.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 05/07/25
//


import SwiftUI

struct MainTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var refreshView = false

    var body: some View {
        TabView {
            HomeView(stepDataController: StepDataController(context: viewContext))
                .tabItem {
                    Label("Home", systemImage: "shoeprints.fill")
                }
                .onAppear {
                                    // Toggle to trigger reloading of SettingsView
                                    refreshView.toggle()
                                }

            StepHistoryView(stepHistoryController: StepHistoryController(context: viewContext))
                .tabItem {
                    Label("History", systemImage: "note.text")
                }
                .onAppear {
                                    // Toggle to trigger reloading of SettingsView
                                    refreshView.toggle()
                                }
            
            SettingsView(settingsController: SettingsController(context: viewContext))
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
        }
    }
}
