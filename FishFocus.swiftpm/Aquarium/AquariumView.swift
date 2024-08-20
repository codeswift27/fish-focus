//
//  Aquarium.swift
//
//
//  Created by Lexline Johnson on 20/02/2024.
//

import SwiftUI

struct AquariumView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\Fish.index)])
    private var fish: FetchedResults<Fish>
    private var fishMessages = ["glub glub", "glub... glub", "glub?", "GLUB GLUB!", "zzzzzz", "...", ":D", "*_*"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.ocean
                    .ignoresSafeArea()
                ForEach(fish) { fish in
                    ForEach((0..<fish.caught), id: \.self) { _ in
                        let isRight = Int.random(in: 0...1) == 0
                        MovingView(
                            position: CGPoint(x: CGFloat.random(in: 0.0...geometry.size.width), y: CGFloat.random(in: 0.0...geometry.size.height)),
                            direction: isRight ? .right : .left,
                            speed: CGFloat.random(in: 1.0...10.0)
                        ) {
                            PopoverView {
                                Text(fishMessages[Int.random(in: 0..<fishMessages.count)])
                                    .padding()
                            } label: {
                                AnimationView(images: [fish.image0, fish.image1], size: fish.name == "Marbled Rockfish" ? 120 : 100)
                                    // Marbled rockfish looks too small!
                                    .rotation3DEffect(.degrees(isRight ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                            }
                        }
                    }
                }
            }
        }
    }
}

// The naming looks so Swift-y yay
struct PopoverView<Label, Content>: View where Label: View, Content: View {
    @ViewBuilder let content: Content
    @ViewBuilder let label: Label
    
    @State private var showPopover: Bool = false
    
    var body: some View {
        label
            .onTapGesture {
                showPopover.toggle()
            }
            .popover(isPresented: $showPopover) {
                content
            }
    }
}

#Preview {
    AquariumView()
}
