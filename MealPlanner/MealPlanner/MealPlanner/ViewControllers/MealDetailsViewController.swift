import UIKit
import SafariServices

class MealDetailsViewController: UIViewController {
  @IBOutlet weak var mealImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var cookTimeLabel: UILabel!
  @IBOutlet weak var tagsLabel: UILabel!
  
  var apiMeal: MealResponse?
  var currentMeal: Meal?
  var currentUser: User?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mealImageView.contentMode = .scaleAspectFill
    mealImageView.clipsToBounds = true
    mealImageView.layer.cornerRadius = 8
    
    if let apiMeal = apiMeal {
      configureFromAPI(meal: apiMeal)
    } else if let meal = currentMeal {
      configureFromCoreData(meal: meal)
    }
  }
  
  func configureFromAPI(meal: MealResponse) {
    nameLabel.text = meal.name
    cookTimeLabel.text = meal.times.cook_time?.display ?? "N/A"
    tagsLabel.text = formatTags(meal.tags)
    
    ImageLoader.shared.loadImage(from: meal.thumbnail_url) { img in
      self.mealImageView.image = img
    }
  }
  
  func configureFromCoreData(meal: Meal) {
    nameLabel.text = meal.name
    cookTimeLabel.text = meal.cookTime
    if let tags = meal.tags as? [String] {
      tagsLabel.text = formatTags(tags)
    }
    
    if let url = meal.imageURL {
      ImageLoader.shared.loadImage(from: url) { img in
        self.mealImageView.image = img
      }
    }
  }
  
  private func formatTags(_ tags: [String]) -> String {
    return tags.joined(separator: ", ")
  }
  
  @IBAction func viewRecipeTapped(_ sender: UIButton) {
    let urlString = apiMeal?.url ?? currentMeal?.url ?? ""
    if let url = URL(string: urlString) {
      let safariVC = SFSafariViewController(url: url)
      present(safariVC, animated: true)
    }
  }
  
  @IBAction func saveFavoriteTapped(_ sender: UIButton) {
    guard let user = currentUser, let apiMeal = apiMeal else { return }
    
    let added = FavoritesManager.shared.addFavorite(mealResponse: apiMeal, for: user)
    
    let alert = UIAlertController(
      title: nil,
      message: added
      ? "Recipe successfully added to favorites"
      : "Recipe already in favorites list",
      preferredStyle: .alert
    )
    
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
  
  @IBAction func addToMealPlanTapped(_ sender: UIButton) {
    guard let user = currentUser else { return }
    
    let mealToAdd: Meal?
    
    if let apiMeal = apiMeal {
      let context = CoreDataManager.shared.context
      let meal = Meal(context: context)
      meal.name = apiMeal.name
      meal.cookTime = apiMeal.times.cook_time?.display
      meal.imageURL = apiMeal.thumbnail_url
      meal.tags = apiMeal.tags as NSArray
      meal.url = apiMeal.url
      mealToAdd = meal
    } else if let meal = currentMeal {
      mealToAdd = meal
    } else {
      return
    }
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let addMealVC = storyboard.instantiateViewController(withIdentifier: "AddMealPlanViewController") as? AddMealPlanViewController else { return }
    
    addMealVC.currentUser = user
    addMealVC.selectedMeal = mealToAdd
    
    addMealVC.onMealAdded = { [weak self] in
      guard let self = self else { return }
      let alert = UIAlertController(title: nil, message: "Recipe successfully added to meal plan", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      self.present(alert, animated: true)
    }
    
    addMealVC.modalPresentationStyle = .formSheet
    present(addMealVC, animated: true)
  }
}
