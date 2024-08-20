//
//  CatalogView.swift
//  Fish Focus
//
//  Created by Lexline Johnson on 04/01/2024.
//

import SwiftUI

struct CatalogView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\Fish.index)])
    private var fish: FetchedResults<Fish>

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))]) {
                ForEach(fish, id: \.self) { fish in
                    if fish.caught == 0 {
                        FishCard(fish: fish)
                            .padding(6)
                    } else {
                        NavigationLink {
                            FishDetail(fish: fish)
                        } label: {
                            FishCard(fish: fish)
                                .padding(6)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Catalog")
    }
}
