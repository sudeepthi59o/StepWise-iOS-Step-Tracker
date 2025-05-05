//
//  StepWiseApp.swift
//  StepWise
//
//  Created by Sudeepthi Rebbalapalli on 5/4/25.
//

import SwiftUI

@main
struct StepWiseApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

