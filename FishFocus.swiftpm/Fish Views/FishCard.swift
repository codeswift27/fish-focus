//
//  FishCard.swift
//
//
//  Created by Lexline Johnson on 15/02/2024.
//

import SwiftUI

struct FishCard: View {
    let fish: Fish
    var body: some View {
        GroupBox {
            Group {
                if fish.caught > 0 {
                    AnimationView(images: [fish.image0, fish.image1])
                } else {
                    let uiImage = UIImage(named: fish.image0)
                    if let colorlessImage = uiImage?.withRenderingMode(.alwaysTemplate) {
                        Image(uiImage: colorlessImage.withTintColor(.darkGray))
                            .interpolation(.none)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                    }
                }
            }
            .frame(maxWidth: 160, maxHeight: 160)
            .padding(.vertical, 20)
        }
        .backgroundStyle(Color.ocean)
    }
}

extension Color {
    public static var ocean: Color {
        return Color(UIColor(named: "ocean") ?? .blue)
    }
}
