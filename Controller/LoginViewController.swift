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
       
    }
    
    func showAlert(message : String) {
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    func loginUser(email: String , password: String) {
    
        let url  = URL(string: "http://localhost:8080/user/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
                    "userEmail": email,
                    "userPassword": password
                ]
        do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                showAlert(message: "JSON oluşturulurken hata oluştu.")
                return
            }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.showAlert(message: "Bağlantı hatası: \(error.localizedDescription)")
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        self.showAlert(message: "Geçersiz yanıt alındı.")
                        return
                    }

                    guard let data = data else {
                        self.showAlert(message: "Boş yanıt alındı.")
                        return
                    }
        do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Response: \(jsonResponse)")

                switch httpResponse.statusCode {
                    case 200:
                    self.showAlertWithAction(message: "Giriş başarılı! Ana sayfaya yönlendiriliyorsunuz.") {
                    self.navigateToHomeScreen()  // Ana sayfaya yönlendirme
                                        }
                    case 401:
                    self.showAlert(message: "Hatalı şifre! Lütfen tekrar deneyin.")
                    case 404:
                    self.showAlert(message: "Kullanıcı bulunamadı! Lütfen kayıt olun.")
                    default:
                    self.showAlert(message: "Hata: \(jsonResponse)")
                     }
                    } catch {
                    self.showAlert(message: "Yanıt işlenirken hata oluştu: \(error.localizedDescription)")
                                }
                            }
                        }.resume()
    }
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        performSegue(withIdentifier: "toProfileUpdate", sender: nil)
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
    func navigateToHomeScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? ViewController {
            homeVC.modalPresentationStyle = .fullScreen
            present(homeVC, animated: true, completion: nil)
        }
    }

    func showAlertWithAction(message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { _ in
            completion()
        })
        present(alert, animated: true)
    }

    
}
