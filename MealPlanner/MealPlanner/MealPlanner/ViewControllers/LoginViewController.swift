import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    usernameTextField.delegate = self
    passwordTextField.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    usernameTextField.text = ""
    passwordTextField.text = ""
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  @IBAction func loginTapped(_ sender: UIButton) {
    guard let username = usernameTextField.text,
          let password = passwordTextField.text,
          !username.isEmpty, !password.isEmpty else {
      showAlert("Please fill both fields")
      return
    }
    
    if let user = AuthManager.shared.login(username: username, password: password) {
      goToMain(with: user)
    } else {
      showAlert("Invalid credentials")
    }
  }
  
  @IBAction func signupTapped(_ sender: UIButton) {
    guard let username = usernameTextField.text,
          let password = passwordTextField.text,
          !username.isEmpty, !password.isEmpty else {
      showAlert("Please fill both fields")
      return
    }
    
    if AuthManager.shared.signup(username: username, password: password) {
      if let user = AuthManager.shared.login(username: username, password: password) {
        goToMain(with: user)
      }
    } else {
      showAlert("Username already exists")
    }
  }
  
  private func goToMain(with user: User) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
      
      if let nav1 = tabBarVC.viewControllers?.first as? UINavigationController,
         let favVC = nav1.topViewController as? FavoritesViewController {
        favVC.currentUser = user
      }
      
      if let nav2 = tabBarVC.viewControllers?.last as? UINavigationController,
         let planVC = nav2.topViewController as? MealPlanViewController {
        planVC.currentUser = user
      }
      
      tabBarVC.modalPresentationStyle = .fullScreen
      present(tabBarVC, animated: true)
    }
  }
  
  private func showAlert(_ message: String) {
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}
