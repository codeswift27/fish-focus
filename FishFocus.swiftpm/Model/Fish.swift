//
//  Fish.swift
//  Fish Focus
//
//  Created by Lexline Johnson on 19/01/2024.
//

import SwiftUI
import CoreData

@objc(Fish)
class Fish: NSManagedObject {
    @NSManaged var caught: Int
    @NSManaged var name: String
    @NSManaged var image0: String
    @NSManaged var image1: String
    @NSManaged var scientificName: String
    @NSManaged var description_: String
    @NSManaged var index: Int
}

extension Fish: Identifiable {
}
