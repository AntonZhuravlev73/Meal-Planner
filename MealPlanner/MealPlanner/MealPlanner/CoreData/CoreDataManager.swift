import CoreData
import UIKit

class CoreDataManager {
  static let shared = CoreDataManager()
  let persistentContainer: NSPersistentContainer

  private init() {
    persistentContainer = NSPersistentContainer(name: "MealPlanner")
    persistentContainer.loadPersistentStores { (description, error) in
      if let error = error {
        fatalError("Unable to load Core Data Store: \(error)")
      }
    }
  }

  var context: NSManagedObjectContext {
    persistentContainer.viewContext
  }

  func saveContext() {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        print("Error saving Core Data: \(error.localizedDescription)")
      }
    }
  }
}
