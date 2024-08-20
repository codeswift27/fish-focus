//
//  The following code is NOT my own and is from
//  https://github.com/ngimelliUW/WiggleAnimationModifier/tree/main by Nicolas
//  Gimelli (ngimelliUW on GitHub). The code creates a view modifier that adds the
//  "jiggle" effect seen when editing the home screen on iOS/iPadOS and selecting
//  shortcuts on the Shortcuts app. Special thanks to them, because I LOVE this
//  effect!
//
//  ------------------------------------------------------------------------------
//
//  MIT License
//
//  Copyright (c) 2023 Nicolas Gimelli
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import SwiftUI

// Utility struct for animation related functions
struct AnimationUtils {
    static func wiggleAnimation(interval: TimeInterval, variance: Double) -> Animation {
        return Animation.easeInOut(duration: randomize(interval: interval, withVariance: variance)).repeatForever(autoreverses: true)
    }

    static func randomize(interval: TimeInterval, withVariance variance: Double) -> TimeInterval {
        let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
        return interval + variance * random
    }
}

struct WiggleRotationModifier: ViewModifier {
    @Binding var isWiggling: Bool
    var rotationAmount: Double

    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: isWiggling ? rotationAmount : 0))
            .animation(isWiggling ? AnimationUtils.wiggleAnimation(interval: 0.14, variance: 0.025) : .default, value: isWiggling)
    }
}

struct WiggleBounceModifier: GeometryEffect {
    var amount: Double
    var bounceAmount: Double

    var animatableData: Double {
        get { amount }
        set { amount = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let bounce = sin(.pi * 2 * animatableData) * bounceAmount
        let translationEffect = CGAffineTransform(translationX: 0, y: CGFloat(bounce))
        return ProjectionTransform(translationEffect)
    }
}

extension View {
    func wiggling(isWiggling: Binding<Bool>, rotationAmount: Double = 3, bounceAmount: Double = 1) -> some View {
        self
            .modifier(WiggleRotationModifier(isWiggling: isWiggling, rotationAmount: rotationAmount))
            .modifier(WiggleBounceModifier(amount: isWiggling.wrappedValue ? 1 : 0, bounceAmount: bounceAmount))
            .animation(isWiggling.wrappedValue ? AnimationUtils.wiggleAnimation(interval: 0.3, variance: 0.025).repeatForever(autoreverses: true) : .default, value: isWiggling.wrappedValue)
    }
}
