//
//  FishSilhouetteView.swift
//  Fish Focus
//
//  Created by Lexline Johnson on 25/02/2024.
//

import SwiftUI

struct FishSilhouetteView: View {
    private var largeFishSilhouette: [String] {
        var array: [String] = []
        for i in 0...5 {
            array.append("largeFishSilhouette\(i)")
        }
        return array
    }
    
    private var smallFishSilhouette: [String] {
        var array: [String] = []
        for i in 0...3 {
            array.append("smallFishSilhouette\(i)")
        }
        return array
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.ocean
                    .ignoresSafeArea()
                // Big fish
                ForEach((0...Int.random(in: 1...2)), id: \.self) { _ in
                    let isRight = Int.random(in: 0...1) == 0
                    MovingView(
                        position: CGPoint(x: CGFloat.random(in: 0.0...geometry.size.width), y: CGFloat.random(in: 0.0...geometry.size.height)),
                        direction: isRight ? .posX : .negX,
                        slope: isRight ? -15/13 + CGFloat.random(in: -0.2...0.2): 15/3 + CGFloat.random(in: -0.2...0.2),
                        speed: CGFloat.random(in: 2.0...4.0),
                        seconds: 0.2,
                        threshold: CGSize(width: 200, height: 200)
                    ) {
                        AnimationView(images: largeFishSilhouette, seconds: 0.5, size: 200)
                            .rotation3DEffect(.degrees(isRight ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                    }
                }
                // Small fish
                ForEach((0...Int.random(in: 1...3)), id: \.self) { _ in
                    let isRight = Int.random(in: 0...1) == 0
                    MovingView(
                        position: CGPoint(x: CGFloat.random(in: 0.0...geometry.size.width), y: CGFloat.random(in: 0.0...geometry.size.height)),
                        direction: isRight ? .posX : .negX,
                        slope: isRight ? 2/3 + CGFloat.random(in: -0.2...0.2): -2/3 + CGFloat.random(in: -0.2...0.2),
                        speed: CGFloat.random(in: 4.0...8.0),
                        seconds: 0.2,
                        threshold: CGSize(width: 50, height: 50)
                    ) {
                        AnimationView(images: smallFishSilhouette, seconds: 0.5, size: 50)
                            .rotation3DEffect(.degrees(isRight ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    }
                }
            }
        }
    }
}

#Preview {
    FishSilhouetteView()
}
