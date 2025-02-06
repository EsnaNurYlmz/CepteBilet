//
//  LoginViewController.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 9.12.2024.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedController.selectedSegmentIndex = 0 
        styleTextFields()
    }
    
    func styleTextFields() {
        let textFields = [ emailTextField, passwordTextField]
        let placeholderColor = UIColor(red: 0.60, green: 0.70, blue: 0.95, alpha: 1.0)

        for textField in textFields {
            textField?.layer.cornerRadius = 15
            textField?.layer.borderWidth = 1
            textField?.layer.borderColor = UIColor.white.cgColor
            textField?.clipsToBounds = true
            
            if let placeholder = textField?.placeholder {
                textField?.attributedPlaceholder = NSAttributedString(
                    string: placeholder,
                    attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
                )
            }
        }
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text , !email.isEmpty,
              let password = passwordTextField.text , !password.isEmpty else{
            showAlert(message: "Lütfen email ve şifrenizi giriniz!")
            return
        }
        loginUser(email: email, password: password)
        showAlert(message: "Giriş Yaptınız. Hoş Geldiniz!")
    }
    
    func showAlert(message : String) {
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    func loginUser(email: String , password: String) {
        
        let url  = URL(string: "https://your-api-endpoint.com/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
                    "email": email,
                    "password": password
                ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data , response , error in
            if let error = error {
                            print("Error: \(error.localizedDescription)")
                            return
            }
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                            print("Response: \(responseString)")
                            
                            // Eğer giriş başarılı ise, ana sayfaya yönlendirme yapabilirsiniz
                            DispatchQueue.main.async {
                    }
              }
            
        }.resume()
    }
    @IBAction func forgotPasswordTapped(_ sender: Any) {
    }
    
    @IBAction func segmentedController(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
                        signUpVC.modalPresentationStyle = .fullScreen
                present(signUpVC, animated: true, completion: nil)
                    }
         }
    }
    
}
