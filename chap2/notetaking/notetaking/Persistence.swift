//
//  Persistence.swift
//  notetaking
//
//  Created by Nikolai Schlegel on 10/25/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newNoteEntry = NoteEntry(context: viewContext)
            newNoteEntry.createdAt = Date()
            newNoteEntry.updatedAt = Date()
            newNoteEntry.content = "(Content)"
            newNoteEntry.title = "(title)"
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "notetaking")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save() {
        let viewContext = container.viewContext
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addNoteEntry() {
        let viewContext = container.viewContext
        // Create a new object of NoteEntry
        let newNoteEntry = NoteEntry(context: viewContext)

        // Fill the object with some data
        // We will update here later.
        newNoteEntry.createdAt = Date()
        newNoteEntry.updatedAt = Date()
        newNoteEntry.title = "Untitled"
        newNoteEntry.content = "TBD"

        save()
    }
    
    func updateNoteEntry(noteEntry: NoteEntry, title: String, content: String) {
        noteEntry.content = content
        noteEntry.title = title
        noteEntry.updatedAt = Date()

        save()
    }
    
    func deleteNoteEntry(noteEntry: NoteEntry) {
        let viewContext = container.viewContext
        viewContext.delete(noteEntry)

        save()
    }
}
