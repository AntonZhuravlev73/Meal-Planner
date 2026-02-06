import Foundation
import CoreData

class AuthManager {
  static let shared = AuthManager()
  private init() {}

  func signup(username: String, password: String) -> Bool {
    let context = CoreDataManager.shared.context
    let request: NSFetchRequest<User> = User.fetchRequest()
    request.predicate = NSPredicate(format: "username == %@", username)

    if let result = try? context.fetch(request), !result.isEmpty {
      return false
    }

    let user = User(context: context)
    user.username = username
    user.password = password

    CoreDataManager.shared.saveContext()
    return true
  }

  func login(username: String, password: String) -> User? {
    let context = CoreDataManager.shared.context
    let request: NSFetchRequest<User> = User.fetchRequest()
    request.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)

    return try? context.fetch(request).first
  }
}
