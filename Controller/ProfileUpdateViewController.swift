//
//  ProfileUpdateViewController.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 9.12.2024.
//

import UIKit

class ProfileUpdateViewController: UIViewController {

    @IBOutlet weak var newNameTextField: UITextField!
    @IBOutlet weak var newSurnameTextField: UITextField!
    @IBOutlet weak var newCountryCodeTextField: UITextField!
    @IBOutlet weak var newPhoneNumberTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    var userId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func profileUpdateTapped(_ sender: UIButton) {

        
        let updateUser = User()
        updateUser.userID = SessionManager.shared.userId;
        updateUser.userName = newNameTextField.text?.isEmpty == false ? newNameTextField.text : nil
        updateUser.userSurname = newSurnameTextField.text?.isEmpty == false ? newSurnameTextField.text : nil
        updateUser.countryCode = newCountryCodeTextField.text?.isEmpty == false ? newCountryCodeTextField.text : nil
        updateUser.userPhoneNumber  = newPhoneNumberTextField.text?.isEmpty == false ? newPhoneNumberTextField.text : nil
        updateUserProfile(user: updateUser)
    }
    
    @IBAction func passwordUpdateTapped(_ sender: UIButton) {
        
        guard let userId = SessionManager.shared.userId , !userId.isEmpty else {
            showAlert(title: "Hata", message: "user ID boş.")
            return
        }
        guard let newPassword = newPasswordTextField.text , !newPassword.isEmpty else {
            showAlert(title: "Hata", message: "Yeni şifre giriniz.")
            return
        }
        updateUserPassword(userId: userId, newPassword: newPassword)
    }
     
    func updateUserProfile( user : User ) {
        let url = URL(string: "http://localhost:8080/user/update")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
                    let jsonData = try JSONEncoder().encode(user)
                    request.httpBody = jsonData
                } catch {
                    showAlert(title: "Hata", message: "Veriler işlenirken bir hata oluştu!")
                    return
                }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.showAlert(title: "Bağlantı Hatası", message: error.localizedDescription)
                            return
                        }
                        
                        guard let httpResponse = response as? HTTPURLResponse else {
                            self.showAlert(title: "Hata", message: "Geçersiz sunucu yanıtı!")
                            return
                        }
                        
                        if httpResponse.statusCode == 200 {
                            self.showAlert(title: "Başarılı", message: "Profil başarıyla güncellendi!")
                        } else {
                            self.showAlert(title: "Hata", message: "Güncelleme başarısız, hata kodu: \(httpResponse.statusCode)")
                        }
                    }
                }
                task.resume()
    }
    
    func updateUserPassword( userId : String , newPassword : String){
        
        let url = URL(string: "http://localhost:8080/user/updatePass")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let passwordUpdateData: [String: Any] = [
                    "userID": userId,
                    "userPassword": newPassword
                ]
        do {
                    let jsonData = try JSONSerialization.data(withJSONObject: passwordUpdateData, options: [])
                    request.httpBody = jsonData
                } catch {
                    showAlert(title: "Hata", message: "Veriler işlenirken bir hata oluştu!")
                    return
                }
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.showAlert(title: "Bağlantı Hatası", message: error.localizedDescription)
                            return
                        }
                        
                        guard let httpResponse = response as? HTTPURLResponse else {
                            self.showAlert(title: "Hata", message: "Geçersiz sunucu yanıtı!")
                            return
                        }
                        
                        if httpResponse.statusCode == 200 {
                            self.showAlert(title: "Başarılı", message: "Şifre başarıyla güncellendi!")
                        } else {
                            self.showAlert(title: "Hata", message: "Şifre güncelleme başarısız, hata kodu: \(httpResponse.statusCode)")
                        }
                    }
                }
                
                task.resume()
    }
    
    func showAlert(title: String, message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
           DispatchQueue.main.async {
               self.present(alert, animated: true, completion: nil)
           }
       }
}
