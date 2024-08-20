//
//  AnimationView.swift
//
//
//  Created by Lexline Johnson on 15/02/2024.
//

import SwiftUI
import Combine

// View for animations
struct AnimationView: View {
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @State private var frame = 0
    
    let images: [String]
    let seconds: Double
    let size: CGFloat
    
    init(images: [String], seconds: Double = 1, size: CGFloat = 100) {
        self.frame = 0
        self.images = images
        self.seconds = seconds
        self.size = size
        self.timer = Timer.publish(every: seconds, on: .main, in: .common).autoconnect()
    }
    
    var body: some View {
        Image(images[frame])
            .interpolation(.none)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size)
            .onReceive(timer) { _ in
                if frame < images.count - 1 {
                    frame += 1
                } else {
                    frame = 0
                }
            }
    }
}

// Moves view in specified direction at specified speed
struct MovingView<V>: View where V: View {
    enum Direction {
        case left, right, up, down, posX, negX
    }
    
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @State var position: CGPoint
    let direction: Direction
    let slope: CGFloat
    let speed: CGFloat
    let seconds: CGFloat
    let threshold: CGSize
    let bounds: CGSize
    
    init(position: CGPoint, direction: Direction = .left, slope: CGFloat = 1, speed: CGFloat = 1, seconds: CGFloat = 0.1, threshold: CGSize = CGSize(width: 50, height: 50), bounds: CGSize = CGSize(width: 1000, height: 1000), @ViewBuilder content: @escaping () -> V) {
        self._position = State(initialValue: position)
        self.direction = direction
        self.slope = slope
        self.speed = speed
        self.seconds = seconds
        self.threshold = threshold
        self.bounds = bounds
        self.content = content()
        self.timer = Timer.publish(every: seconds, on: .main, in: .common).autoconnect()
    }
    
    @ViewBuilder let content: V
    
    var body: some View {
        content
            .position(x: position.x, y: position.y)
            .onReceive(timer) { _ in
                if position.x < -threshold.width {
                    position.x = bounds.width + threshold.width
                } else if position.x > bounds.width + threshold.width {
                    position.x = -threshold.width
                } else if position.y < -threshold.height {
                    position.y = bounds.height + threshold.height
                } else if position.y > bounds.width + threshold.height {
                    position.y = -threshold.height
                } else {
                    withAnimation {
                        switch direction {
                        case .left:
                            position.x -= speed
                        case .right:
                            position.x += speed
                        case .up:
                            position.y -= speed
                        case .down:
                            position.y += speed
                        case .posX:
                            position.x += speed
                            position.y += speed * slope
                        case .negX:
                            position.x -= speed
                            position.y -= speed * slope
                        }
                    }
                }
            }
    }
}

#Preview {
    AnimationView(images: ["pennantCoralfish0", "pennantCoralfish1"])
}
