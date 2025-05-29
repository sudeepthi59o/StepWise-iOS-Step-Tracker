//
//  ActionButton.swift
//  Sudeepthi Rebbalapalli (surebbal@iu.edu), Rajesh Kumar Reddy Avula (rajavula@iu.edu)
//  App Name: StepWise
//  Submission Date: 05/07/25
//

import SwiftUI

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
