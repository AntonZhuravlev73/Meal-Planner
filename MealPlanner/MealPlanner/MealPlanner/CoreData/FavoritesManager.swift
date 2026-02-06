import Foundation
import CoreData

class FavoritesManager {
  static let shared = FavoritesManager()
  private init() {}

  func addFavorite(mealResponse: MealResponse, for user: User) -> Bool {
    let context = CoreDataManager.shared.context

    let request: NSFetchRequest<Meal> = Meal.fetchRequest()
    request.predicate = NSPredicate(format: "id == %d AND user == %@", mealResponse.id, user)

    if let existing = try? context.fetch(request), !existing.isEmpty {
      return false
    }

    let meal = Meal(context: context)
    meal.id = Int64(mealResponse.id)
    meal.name = mealResponse.name
    meal.imageURL = mealResponse.thumbnail_url
    meal.cookTime = mealResponse.times.cook_time?.display
    meal.url = mealResponse.url
    meal.tags = mealResponse.tags as NSArray
    meal.user = user
    user.addToFavorites(meal)
    CoreDataManager.shared.saveContext()

    return true
  }

  func fetchFavorites(for user: User) -> [Meal] {
    let request: NSFetchRequest<Meal> = Meal.fetchRequest()
    request.predicate = NSPredicate(format: "user == %@", user)
    return (try? CoreDataManager.shared.context.fetch(request)) ?? []
  }

  func removeFavorite(meal: Meal) {
    CoreDataManager.shared.context.delete(meal)
    CoreDataManager.shared.saveContext()
  }
}
