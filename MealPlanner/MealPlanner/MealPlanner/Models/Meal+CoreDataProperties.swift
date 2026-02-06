import Foundation
import CoreData


extension Meal {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
    return NSFetchRequest<Meal>(entityName: "Meal")
  }
  
  @NSManaged public var cookTime: String?
  @NSManaged public var id: Int64
  @NSManaged public var imageURL: String?
  @NSManaged public var name: String?
  @NSManaged public var tags: NSArray?
  @NSManaged public var url: String?
  @NSManaged public var user: User?
  
}

extension Meal : Identifiable {
  
}
