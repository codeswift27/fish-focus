//
//  MyApp.swift
//  Fish Focus
//
//  Created by Lexline Johnson on 25/01/2024.
//

import SwiftUI

@main
struct MyApp: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    let persistenceController = Persistence.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .sheet(isPresented: $isOnboarding, onDismiss: {
                    // Add fish on first launch
                    let viewContext = persistenceController.container.viewContext
                    
                    let pennantCoralfish = Fish(context: viewContext)
                    pennantCoralfish.caught = 0
                    pennantCoralfish.name = "Pennant Coralfish"
                    pennantCoralfish.image0 = "pennantCoralfish0"
                    pennantCoralfish.image1 = "pennantCoralfish1"
                    pennantCoralfish.scientificName = "Heniochus acuminatus"
                    pennantCoralfish.description_ = "Also known as longfin bannerfish, the pennant coralfish is a black and white fish with a long white dorsal fin and yellow tail fin. Pennant coralfish are often found alone or in small groups at the edge of coral reefs, and they primarily feed on zooplankton and small invertebrates. They are also sometimes seen eating parasites on other fish."
                    pennantCoralfish.index = 1
                    
                    let blueTang = Fish(context: viewContext)
                    blueTang.caught = 0
                    blueTang.name = "Palette Surgeonfish"
                    blueTang.image0 = "paletteSurgeonfish0"
                    blueTang.image1 = "paletteSurgeonfish1"
                    blueTang.scientificName = "Paracanthurus hepatus"
                    blueTang.description_ = "The palette surgeonfish, or blue tang, is a bright blue fish with a black band along its side and blue and yellow fins. Pallete surgeonfish are native to the Pacific and Indian oceans, and they are found in loose groups in outer reefs. They feed on zooplankton and algae. Surgeonfish get their name from their ability to use their caudal spine to slash other fish."
                    blueTang.index = 2
                    
                    let moorishIdol = Fish(context: viewContext)
                    moorishIdol.caught = 0
                    moorishIdol.name = "Moorish Idol"
                    moorishIdol.image0 = "moorishIdol0"
                    moorishIdol.image1 = "moorishIdol1"
                    moorishIdol.scientificName = "Zanclus cornutus"
                    moorishIdol.description_ = "While they look similar to pennant coralfish, moorish idols are their own species of fish in the Zanclidae family. Similarly to the pennant coralfish, the moorish idol has a long dorsal fin; however, its tail is black and it has yellow on its body. Moorish Idols are found in both small groups and schools of over 100 fish. They feed on algae, sponges, and small invertebrates."
                    moorishIdol.index = 3
                    
                    let clownfish = Fish(context: viewContext)
                    clownfish.caught = 0
                    clownfish.name = "Clown Anemonefish"
                    clownfish.image0 = "clownAnemonefish0"
                    clownfish.image1 = "clownAnemonefish1"
                    clownfish.scientificName = "Amphiprion ocellaris"
                    clownfish.description_ = "The clown anemonefish, also called simply clownfish, is one of the 30 species of the _Amphiprion_ genus. Clownfish are identified by their bright orange bodies and vertical white stripes. They are known for their ability to hide within the poisonous tentacles of sea anemones due to a protective coating of mucus on their skin. Clownfish are also all born male with the ability to change into females as adults. They feed on zooplankton, copepods, and algae."
                    clownfish.index = 4
                    
                    let marbledRockfish = Fish(context: viewContext)
                    marbledRockfish.caught = 0
                    marbledRockfish.name = "False Kelpfish"
                    marbledRockfish.image0 = "falseKelpfish0"
                    marbledRockfish.image1 = "falseKelpfish1"
                    marbledRockfish.scientificName = "Sebastiscus marmoratus"
                    marbledRockfish.description_ = "Also known as marbled rockfish, the false kelpfish has a marbled yellow, brown, or red pattern. It also resembeles the kelpfish, although the false kelpfish has a larger mouth and spiny operculum. False kelpfish live in coastal marine waters and feed on amphipoda, crabs, and cephalopods."
                    marbledRockfish.index = 5

                    do {
                        try viewContext.save()
                    } catch {
                        print("Could not add fish: \(error)")
                    }
                    
                    let defaults = UserDefaults.standard
                    defaults.setValue(false, forKey: "isOnboarding")
                }) {
                    OnboardingView()
                }
        }
    }
}
