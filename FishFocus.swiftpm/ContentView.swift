//
//  ContentView.swift
//  Fish Focus
//
//  Created by Lexline Johnson on 31/12/2023.
//
//  Sources ♥︎
//  Fish data was referenced from the USGS Nonindigenous Aquatic Species (NAS)
//  database and the Australian Museum. Specifically from the following links:
//  https://nas.er.usgs.gov/queries/FactSheet.aspx?speciesID=3019
//  https://nas.er.usgs.gov/queries/FactSheet.aspx?speciesID=3339
//  https://nas.er.usgs.gov/queries/factsheet.aspx?SpeciesID=2303
//  https://nas.er.usgs.gov/queries/FactSheet.aspx?SpeciesID=3243
//  https://australian.museum/learn/animals/fishes/false-kelpfish-sebastiscus-marmoratus/
//
//  Code for WiggleModifier is from
//  https://github.com/ngimelliUW/WiggleAnimationModifier/tree/main by Nicolas
//  Gimelli (ngimelliUW on GitHub).
//
//  Thank you, and please enjoy! :)
//

import SwiftUI

struct ContentView: View {
    // Sidebar views
    private enum ContentSelection: Hashable {
        case tasks, catalog, aquarium
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var contentSelection: ContentSelection?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $contentSelection) {
                Text("Tasks")
                    .tag(ContentSelection.tasks)
                Text("Catalog")
                    .tag(ContentSelection.catalog)
                Text("Aquarium")
                    .tag(ContentSelection.aquarium)
            }
            .navigationTitle("Focus")
        } detail: {
            NavigationStack {
                switch contentSelection {
                case .tasks:
                    TaskView()
                case .catalog:
                    CatalogView()
                case .aquarium:
                    AquariumView()
                case nil:   // if no view is selected
                    Text("Glub glub... glub!")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
