import CoreData

/// `Record`CoreData persistency module.
struct RecordPersistence {
    /// Shared persisten
    static let shared = RecordPersistence()

    /// Record value for Previews.
    static var preview: RecordPersistence = {
        let result = RecordPersistence(inMemory: true)
        let viewContext = result.container.viewContext

        /// Generate 10 mock records.
        for _ in 0..<10 {
            let newItem = Record(context: viewContext)
            newItem.timestamp = Date()
            newItem.score = Int32.random(in: 0...5000)
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    /// CoreData container.
    let container: NSPersistentContainer

    /// Record persistency initializer.
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "g2048")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
