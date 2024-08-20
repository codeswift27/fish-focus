//
//  OnboardingView.swift
//  Fish Focus
//
//  Created by Lexline Johnson on 24/02/2024.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 48) {
            Text("Welcome to FishFocus")
                .font(.largeTitle)
                .bold()
            VStack(alignment: .listRowSeparatorLeading, spacing: 24) {
                HStack(spacing: 18) {
                    VStack(alignment: .center) {
                        Image(systemName: "checklist")
                            .font(.largeTitle)
                    }
                    VStack(alignment: .leading) {
                        Text("Organize your to-do list")
                            .font(.headline)
                        Text("Create tasks and sort by priority and deadline.")
                            .foregroundStyle(.secondary)
                    }
                }
                HStack(spacing: 18) {
                    VStack(alignment: .center) {
                        Image(systemName: "timer")
                            .font(.largeTitle)
                    }
                    VStack(alignment: .leading) {
                        Text("Focus on tasks")
                            .font(.headline)
                        Text("Set a timer to complete your tasks with relaxing visuals.")
                            .foregroundStyle(.secondary)
                    }
                }
                HStack(spacing: 18) {
                    VStack(alignment: .center) {
                        Image(systemName: "fish")
                            .font(.largeTitle)
                    }
                    VStack(alignment: .leading) {
                        Text("Collect pixel fish")
                            .font(.headline)
                        Text("Complete tasks to add fish to your aquarium.")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            Button {
                dismiss()
            } label: {
                HStack {
                    Spacer()
                    Text("Continue")
                        .bold()
                        .padding(10)
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: 360)
    }
}

#Preview {
    OnboardingView()
}
