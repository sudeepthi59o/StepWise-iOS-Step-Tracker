//
//  MainTabView.swift
//  StepWise
//
//  Created by Sudeepthi Rebbalapalli on 5/4/25.
//


import SwiftUI

struct MainTabView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        TabView {
            HomeView(stepDataModel: StepDataModel(context: viewContext))
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            StepHistoryView(model: StepHistoryModel(context: viewContext))
                .tabItem {
                    Label("History", systemImage: "figure.walk")
                }
            
            SettingsView(viewModel: SettingsModel())
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
        }
    }
}
