import UIKit

class FavoritesViewController: UITableViewController {
  var currentUser: User?
  var sectionedFavorites: [String: [Meal]] = [:]
  var tagSections: [String] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .search,
      target: self,
      action: #selector(searchTapped)
    )

    navigationItem.leftBarButtonItem = UIBarButtonItem(
      title: "Logout",
      style: .plain,
      target: self,
      action: #selector(logoutTapped)
    )
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let user = currentUser else { return }
    let favorites = FavoritesManager.shared.fetchFavorites(for: user)

    sectionedFavorites.removeAll()
    for meal in favorites {
      if let tags = meal.tags as? [String] {
        for tag in tags {
          sectionedFavorites[tag, default: []].append(meal)
        }
      }
    }
    tagSections = Array(sectionedFavorites.keys).sorted()

    if favorites.isEmpty {
      let emptyView = UIView(frame: tableView.bounds)

      let label1 = UILabel()
      label1.text = "Nothing is here"
      label1.font = UIFont.boldSystemFont(ofSize: 20)
      label1.textAlignment = .center
      label1.translatesAutoresizingMaskIntoConstraints = false

      let label2 = UILabel()
      label2.text = "Search some recipes"
      label2.font = UIFont.systemFont(ofSize: 16)
      label2.textColor = .gray
      label2.textAlignment = .center
      label2.translatesAutoresizingMaskIntoConstraints = false

      emptyView.addSubview(label1)
      emptyView.addSubview(label2)

      NSLayoutConstraint.activate([
        label1.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
        label1.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -10),
        label2.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
        label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 8)
      ])

      tableView.backgroundView = emptyView
    } else {
      tableView.backgroundView = nil
    }

    tableView.reloadData()
  }

  @objc func searchTapped() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
      searchVC.currentUser = currentUser
      navigationController?.pushViewController(searchVC, animated: true)
    }
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    tagSections.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    sectionedFavorites[tagSections[section]]?.count ?? 0
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    tagSections[section]
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
    if let meal = sectionedFavorites[tagSections[indexPath.section]]?[indexPath.row] {
      cell.textLabel?.text = meal.name
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let meal = sectionedFavorites[tagSections[indexPath.section]]?[indexPath.row] {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      if let detailsVC = storyboard.instantiateViewController(withIdentifier: "MealDetailsViewController") as? MealDetailsViewController {
        detailsVC.currentMeal = meal
        detailsVC.currentUser = currentUser
        navigationController?.pushViewController(detailsVC, animated: true)
      }
    }
  }

  @objc func logoutTapped() {
    currentUser = nil
    presentingViewController?.dismiss(animated: true)
  }
}
