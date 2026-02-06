import Foundation
import CoreData


extension User {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
    return NSFetchRequest<User>(entityName: "User")
  }

  @NSManaged public var username: String?
  @NSManaged public var password: String?
  @NSManaged public var favorites: NSSet?
  @NSManaged public var mealPlan: NSSet?
  
}

extension User {

  @objc(addFavoritesObject:)
  @NSManaged public func addToFavorites(_ value: Meal)

  @objc(removeFavoritesObject:)
  @NSManaged public func removeFromFavorites(_ value: Meal)

  @objc(addFavorites:)
  @NSManaged public func addToFavorites(_ values: NSSet)

  @objc(removeFavorites:)
  @NSManaged public func removeFromFavorites(_ values: NSSet)

}

extension User {

  @objc(addMealPlanObject:)
  @NSManaged public func addToMealPlan(_ value: MealPlan)

  @objc(removeMealPlanObject:)
  @NSManaged public func removeFromMealPlan(_ value: MealPlan)

  @objc(addMealPlan:)
  @NSManaged public func addToMealPlan(_ values: NSSet)

  @objc(removeMealPlan:)
  @NSManaged public func removeFromMealPlan(_ values: NSSet)

}

extension User : Identifiable {

}
