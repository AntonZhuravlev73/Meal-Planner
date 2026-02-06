import UIKit

class AddMealPlanViewController: UIViewController {
  var currentUser: User?
  var selectedMeal: Meal?
  var onMealAdded: (() -> Void)?
  
  @IBOutlet weak var datePicker: UIPickerView!
  @IBOutlet weak var mealTypeSegment: UISegmentedControl!
  
  private var availableDates: [Date] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    availableDates = (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: today) }
    
    datePicker.dataSource = self
    datePicker.delegate = self
  }
  
  @IBAction func saveTapped(_ sender: UIButton) {
    let selectedDate = availableDates[datePicker.selectedRow(inComponent: 0)]
    let mealTypes = ["Breakfast", "Lunch", "Dinner"]
    let selectedType = mealTypes[mealTypeSegment.selectedSegmentIndex]
    
    guard let user = currentUser, let meal = selectedMeal else { return }
    
    MealPlanManager.shared.replaceMealIfExists(date: selectedDate, type: selectedType, meal: meal, for: user)
    
    dismiss(animated: true) { [weak self] in
      self?.onMealAdded?()
    }
  }
  
  @IBAction func cancelTapped(_ sender: UIButton) {
    dismiss(animated: true)
  }
}

extension AddMealPlanViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    availableDates.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: availableDates[row])
  }
}
