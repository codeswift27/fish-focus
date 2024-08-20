//
//  FishDetail.swift
//
//
//  Created by Lexline Johnson on 20/02/2024.
//

import SwiftUI

struct FishDetail: View {
    let fish: Fish
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.ocean
                ScrollView {
                    ZStack {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 400))], spacing: 200) {
                            AnimationView(images: [fish.image0, fish.image1], size: 320)
                                .frame(maxWidth: 400, maxHeight: 400)
                            GroupBox {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(String(format: "%02d", fish.index))
                                            .font(.title2)
                                            .foregroundStyle(Color.accentColor)
                                        Text(fish.name)
                                            .font(.title2)
                                    }
                                    .padding(.bottom, 4)
                                    Text("Scientific name: \(fish.scientificName)")
                                    Text("Number caught: \(fish.caught)")
                                        .padding(.bottom, 6)
                                    Text(fish.description_)
                                }
                            }
                            .backgroundStyle(Color(UIColor.systemBackground).opacity(0.72))
                            .frame(maxWidth: 400, maxHeight: 400)
                        }
                        .padding(.horizontal, 75)
                    }
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .ignoresSafeArea()
        .navigationTitle("Info")
    }
}
