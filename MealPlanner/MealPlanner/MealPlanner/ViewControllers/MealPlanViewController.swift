import UIKit
import SafariServices

class MealPlanViewController: UITableViewController {
  var currentUser: User?
  var plansByDate: [Date: [String: Meal]] = [:]
  var sortedDates: [Date] = []
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadMealPlans()
  }
  
  private func loadMealPlans() {
    guard let user = currentUser else { return }
    let plans = MealPlanManager.shared.fetchPlans(for: user)
    
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    let next7Days = (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: today) }
    
    plansByDate.removeAll()
    for date in next7Days {
      plansByDate[date] = [:]
    }
    
    for plan in plans {
      guard let date = plan.date, let type = plan.mealType, let meal = plan.meal else { continue }
      if next7Days.contains(date) {
        plansByDate[date]?[type] = meal
      }
    }
    
    sortedDates = next7Days
    tableView.reloadData()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return sortedDates.count
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: sortedDates[section])
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let types = ["Breakfast", "Lunch", "Dinner"]
    let type = types[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "MealPlanCell", for: indexPath)
    let date = sortedDates[indexPath.section]
    
    if let meal = plansByDate[date]?[type] {
      cell.textLabel?.text = "\(type): \(meal.name ?? "")"
      cell.textLabel?.textColor = .label
    } else {
      cell.textLabel?.text = "\(type): empty"
      cell.textLabel?.textColor = .secondaryLabel
    }
    
    cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if let header = view as? UITableViewHeaderFooterView {
      header.textLabel?.textColor = .black
      header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let types = ["Breakfast", "Lunch", "Dinner"]
    let type = types[indexPath.row]
    let date = sortedDates[indexPath.section]
    
    guard let meal = plansByDate[date]?[type], let urlString = meal.url, let url = URL(string: urlString) else {
      return
    }
    
    let safariVC = SFSafariViewController(url: url)
    present(safariVC, animated: true)
  }
}
