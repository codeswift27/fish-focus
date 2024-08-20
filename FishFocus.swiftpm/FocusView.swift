//
//  FocusView.swift
//  Fish Focus
//
//  Created by Lexline Johnson on 17/02/2024.
//

import SwiftUI

struct FocusView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\Fish.index)])
    private var fish: FetchedResults<Fish>
    @State private var caughtFish: Fish?
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining: (hours: Int, minutes: Int, seconds: Int)
    @State private var isCompleted: Bool = false
    @State private var showTimer: Bool = true
    @State private var showAlert: Bool = false
    @State private var alertNum: Int = 0
    
    private let alerts = [(title: "You're scaring away the fish!", message: "Please come back after you have finished your task."), (title: "The fish are getting suspicious...", message: "Do your task so the fish don't swim away!"), (title: "The fish got away :(", message: "Try to stay focused next time and maybe you'll get a big catch!")]
    // Definitely will add a lot more fun alert messages and maybe an easter egg
    
    init(minutes: Int) {
        _timeRemaining = State(initialValue: (Int(floor(Double(minutes / 60))), minutes % 60, 0))
    }
    
    var body: some View {
        ZStack {
            if !isCompleted {
                Group {
                    if showTimer {
                        Text(timeRemaining.hours > 0 ? String(format: "%02d:%02d:%02d", timeRemaining.hours, timeRemaining.minutes, timeRemaining.seconds) : String(format: "%02d:%02d", timeRemaining.minutes, timeRemaining.seconds))
                            .font(.system(size: 60))
                    } else {
                        Color.clear
                    }
                }
                .onReceive(timer) { _ in
                    if timeRemaining.seconds > 0 {
                        timeRemaining.seconds -= 1
                    } else if timeRemaining.minutes > 0 {
                        timeRemaining.minutes -= 1
                        timeRemaining.seconds = 59
                    } else if timeRemaining.hours > 0 {
                        timeRemaining.hours -= 1
                        timeRemaining.minutes = 59
                        timeRemaining.seconds = 59
                    } else {
                        timer.upstream.connect().cancel()
                        isCompleted = true
                        let fishID = Int.random(in: 0..<fish.count)
                        caughtFish = fish[fishID]
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showTimer.toggle() }) {
                            Text(showTimer ? "Hide Timer" : "Show Timer")
                                .transaction { transaction in
                                    transaction.animation = nil
                                }
                        }
                        Spacer()
                        Button("Skip timer\n(developer privileges)") {
                            timeRemaining = (0, 0, 0)
                            timer.upstream.connect().cancel()
                            isCompleted = true
                            let fishID = Int.random(in: 0..<fish.count)
                            caughtFish = fish[fishID]
                        }
                        Spacer()
                    }
                    .padding(.bottom, 120)
                }
            } else {
                if let caughtFish = caughtFish {
                    ZStack {
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                AnimationView(images: [caughtFish.image0, caughtFish.image1], size: 160)
                                Text("You caught a \(caughtFish.name)!")
                                    .font(.title2)
                                    .padding(.top, 20)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .alert(alerts[alertNum].title, isPresented: $showAlert) {
            Button("Okay") {
                if alertNum < 2 {
                    alertNum += 1
                    self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                } else {
                    dismiss()
                }
            }
        } message: { Text(alerts[alertNum].message) }
        .onTapGesture {
            if !isCompleted {
                timer.upstream.connect().cancel()
                showAlert = true
            } else {
                if let caughtFish = caughtFish {
                    caughtFish.caught += 1
                    do {
                        try viewContext.save()
                    } catch {
                        print("Error adding fish: \(error)")
                    }
                }
                dismiss()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if !isCompleted && (newPhase == .inactive || newPhase == .background) {
                timer.upstream.connect().cancel()
                showAlert = true
            }
        }
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}

#Preview {
    FocusView(minutes: 1)
}
