//
//  Persistence.swift
//  Fish Focus
//
//  Created by Lexline Johnson on 25/01/2024.
//

import SwiftUI
import CoreData

class Persistence {
    static let shared = Persistence()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        // Create Task entity
        let taskEntity = NSEntityDescription()
        taskEntity.name = "Task"
        taskEntity.managedObjectClassName = "Task"
        
        let titleAttribute = NSAttributeDescription()
        titleAttribute.name = "title"
        titleAttribute.type = .string
        taskEntity.properties.append(titleAttribute)
        
        let notesAttribute = NSAttributeDescription()
        notesAttribute.name = "notes"
        notesAttribute.type = .string
        taskEntity.properties.append(notesAttribute)
        
        let deadlineAttribute = NSAttributeDescription()
        deadlineAttribute.name = "deadline"
        deadlineAttribute.type = .date
        taskEntity.properties.append(deadlineAttribute)
        
        let priorityAttribute = NSAttributeDescription()
        priorityAttribute.name = "priorityValue"
        priorityAttribute.type = .integer64
        taskEntity.properties.append(priorityAttribute)
        
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.type = .uuid
        taskEntity.properties.append(idAttribute)
        
        // Create Fish entity
        let fishEntity = NSEntityDescription()
        fishEntity.name = "Fish"
        fishEntity.managedObjectClassName = "Fish"
        
        let caughtAttribute = NSAttributeDescription()
        caughtAttribute.name = "caught"
        caughtAttribute.type = .integer64
        fishEntity.properties.append(caughtAttribute)
        
        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "name"
        nameAttribute.type = .string
        fishEntity.properties.append(nameAttribute)
        
        let image0Attribute = NSAttributeDescription()
        image0Attribute.name = "image0"
        image0Attribute.type = .string
        fishEntity.properties.append(image0Attribute)
        
        let image1Attribute = NSAttributeDescription()
        image1Attribute.name = "image1"
        image1Attribute.type = .string
        fishEntity.properties.append(image1Attribute)
        
        let scientificNameAttribute = NSAttributeDescription()
        scientificNameAttribute.name = "scientificName"
        scientificNameAttribute.type = .string
        fishEntity.properties.append(scientificNameAttribute)
        
        let descriptionAttribute = NSAttributeDescription()
        descriptionAttribute.name = "description_"
        descriptionAttribute.type = .string
        fishEntity.properties.append(descriptionAttribute)
        
        let indexAttribute = NSAttributeDescription()
        indexAttribute.name = "index"
        indexAttribute.type = .integer64
        fishEntity.properties.append(indexAttribute)
        
        let model = NSManagedObjectModel()
        model.entities = [taskEntity, fishEntity]
        
        let container = NSPersistentContainer(name: "Model", managedObjectModel: model)
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("failed with: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        self.container = container
    }
}
