import Foundation
import CoreData


extension MealPlan {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<MealPlan> {
    return NSFetchRequest<MealPlan>(entityName: "MealPlan")
  }
  
  @NSManaged public var date: Date?
  @NSManaged public var mealType: String?
  @NSManaged public var meal: Meal?
  @NSManaged public var user: User?
  
}

extension MealPlan : Identifiable {
  
}
