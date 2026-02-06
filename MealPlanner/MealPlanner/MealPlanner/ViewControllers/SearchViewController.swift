import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {
  var results: [MealResponse] = []
  var currentUser: User?
  private var searchBar: UISearchBar!

  private let rowHeight: CGFloat = 120
  private let imageSize: CGFloat = 100

  private let infoLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    label.textColor = .secondaryLabel
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    searchBar = UISearchBar()
    searchBar.delegate = self
    navigationItem.titleView = searchBar

    tableView.rowHeight = rowHeight
    tableView.tableFooterView = UIView()
    tableView.backgroundView = infoLabel

    infoLabel.text = "Search some recipes"
    infoLabel.isHidden = false
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchBar.becomeFirstResponder()
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.count > 2 {
      infoLabel.isHidden = true
    } else {
      infoLabel.text = "Search some recipes"
      infoLabel.isHidden = false
    }
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    guard let query = searchBar.text, !query.isEmpty else { return }

    APIManager.shared.searchRecipes(query: query) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let meals):
          self.results = meals
          self.tableView.reloadData()

          if meals.isEmpty {
            self.infoLabel.text = "Nothing found"
            self.infoLabel.isHidden = false
          } else {
            self.infoLabel.isHidden = true
          }

        case .failure(let error):
          print("Error: \(error)")
          self.infoLabel.text = "Nothing found"
          self.infoLabel.isHidden = false
        }
      }
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    results.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") ??
    UITableViewCell(style: .default, reuseIdentifier: "SearchCell")

    let meal = results[indexPath.row]
    cell.textLabel?.text = meal.name
    cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    cell.textLabel?.numberOfLines = 2

    ImageLoader.shared.loadImage(from: meal.thumbnail_url) { image in
      if let img = image {
        let resized = img.resize(to: CGSize(width: self.imageSize, height: self.imageSize))
        cell.imageView?.image = resized
        cell.setNeedsLayout()
      }
    }

    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedMeal = results[indexPath.row]
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let detailsVC = storyboard.instantiateViewController(withIdentifier: "MealDetailsViewController") as? MealDetailsViewController {
      detailsVC.apiMeal = selectedMeal
      detailsVC.currentUser = currentUser
      navigationController?.pushViewController(detailsVC, animated: true)
    }
  }
}

extension UIImage {
  func resize(to targetSize: CGSize) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: targetSize)
    return renderer.image { _ in
      self.draw(in: CGRect(origin: .zero, size: targetSize))
    }
  }
}
