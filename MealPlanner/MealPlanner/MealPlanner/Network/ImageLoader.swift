import UIKit

class ImageLoader {
  static let shared = ImageLoader()
  private var cache = NSCache<NSString, UIImage>()
  
  func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
    if let cached = cache.object(forKey: urlString as NSString) {
      completion(cached)
      return
    }
    
    guard let url = URL(string: urlString) else {
      completion(nil)
      return
    }
    
    URLSession.shared.dataTask(with: url) { data, _, _ in
      var image: UIImage? = nil
      if let data = data {
        image = UIImage(data: data)
        if let image = image {
          self.cache.setObject(image, forKey: urlString as NSString)
        }
      }
      DispatchQueue.main.async {
        completion(image)
      }
    }.resume()
  }
}
