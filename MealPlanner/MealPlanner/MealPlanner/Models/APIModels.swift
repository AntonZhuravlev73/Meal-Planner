import Foundation

struct APIResponse: Codable {
  let message: String?
  let data: RecipeData
  let error: String?
}

struct RecipeData: Codable {
  let count: Int
  let items: [MealResponse]
}

struct MealResponse: Codable {
  let id: Int
  let name: String
  let url: String
  let times: MealTimes
  let thumbnail_url: String
  let tags: [String]

  struct MealTimes: Codable {
    let cook_time: CookTime?

    struct CookTime: Codable {
      let display: String?
    }
  }
}
