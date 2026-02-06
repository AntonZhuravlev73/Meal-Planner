import Foundation
import CoreData

class MealPlanManager {
  static let shared = MealPlanManager()
  private init() {}

  func replaceMealIfExists(date: Date, type: String, meal: Meal, for user: User) {
    let context = CoreDataManager.shared.context

    let request: NSFetchRequest<MealPlan> = MealPlan.fetchRequest()
    request.predicate = NSPredicate(format: "date == %@ AND mealType == %@ AND user == %@", date as CVarArg, type, user)

    if let existing = try? context.fetch(request), let plan = existing.first {
      plan.meal = meal
    } else {
      let newPlan = MealPlan(context: context)
      newPlan.date = date
      newPlan.mealType = type
      newPlan.meal = meal
      newPlan.user = user
      user.addToMealPlan(newPlan)
    }

    CoreDataManager.shared.saveContext()
  }

  func fetchPlans(for user: User) -> [MealPlan] {
    let request: NSFetchRequest<MealPlan> = MealPlan.fetchRequest()
    request.predicate = NSPredicate(format: "user == %@", user)
    return (try? CoreDataManager.shared.context.fetch(request)) ?? []
  }
}
