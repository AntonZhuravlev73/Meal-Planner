import Foundation

struct APIManager {
  static let shared = APIManager()
  private init() {}
  
  private let baseURL = "https://tasty-api1.p.rapidapi.com"
  private let headers = [
    "x-rapidapi-key": "c964da7d1dmsh56ba7c5cc163da4p16fc97jsn6567d1af3613",
    "x-rapidapi-host": "tasty-api1.p.rapidapi.com"
  ]
  
  func searchRecipes(query: String, completion: @escaping (Result<[MealResponse], Error>) -> Void) {
    let urlString = "\(baseURL)/recipe/search?query=\(query)&page=1&perPage=20"
    guard let url = URL(string: urlString) else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
    
    URLSession.shared.dataTask(with: request) { data, _, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      guard let data = data else { return }
      do {
        let result = try JSONDecoder().decode(APIResponse.self, from: data)
        completion(.success(result.data.items))
      } catch {
        completion(.failure(error))
      }
    }.resume()
  }
}
