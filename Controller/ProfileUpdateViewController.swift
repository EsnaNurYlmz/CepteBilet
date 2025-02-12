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
    @IBOutlet weak var newBirthDateTextField: UITextField!
    @IBOutlet weak var newGenderTextField: UITextField!
    @IBOutlet weak var newCountryCodeTextField: UITextField!
    @IBOutlet weak var newPhoneNumberTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    var userId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserIdFromBackend()
    
        userId = UserDefaults.standard.string(forKey: "userID")
    }
    
    @IBAction func profileUpdateTapped(_ sender: UIButton) {
        updateProfile()
    }
    
    @IBAction func passwordUpdateTapped(_ sender: UIButton) {
    }
    func fetchUserIdFromBackend() {
            guard let url = URL(string: "https://api.example.com/getUserId") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.showAlert(message: "Kullanıcı kimliği alınamadı: \(error.localizedDescription)")
                        return
                    }
                    
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let id = json["userId"] as? String {
                        self.userId = id
                    } else {
                        self.showAlert(message: "Kullanıcı kimliği alınamadı.")
                    }
                }
            }
            task.resume()
        }
    
    func updateProfile() {
        
        guard let userId = userId else {
                   showAlert(message: "Kullanıcı kimliği bulunamadı. Lütfen tekrar giriş yapın.")
                   return
               }
               
               let url = URL(string: "https://api.example.com/users/\(userId)")!
               var updateData = [String: Any]()
               
               if let newName = newNameTextField.text, !newName.isEmpty {
                   updateData["userName"] = newName
               }
               if let newSurname = newSurnameTextField.text, !newSurname.isEmpty {
                   updateData["userSurname"] = newSurname
               }
               if let newBirthDate = newBirthDateTextField.text, !newBirthDate.isEmpty {
                   updateData["userBirthDate"] = newBirthDate
               }
               if let newGender = newGenderTextField.text, !newGender.isEmpty {
                   updateData["userGender"] = newGender
               }
               if let newCountryCode = newCountryCodeTextField.text, !newCountryCode.isEmpty {
                   updateData["countryCode"] = newCountryCode
               }
               if let newPhoneNumber = newPhoneNumberTextField.text, !newPhoneNumber.isEmpty {
                   updateData["userPhoneNumber"] = newPhoneNumber
               }
               
               guard !updateData.isEmpty else {
                   showAlert(message: "Lütfen güncellemek istediğiniz bilgileri girin.")
                   return
               }
               
               sendPatchRequest(url: url, data: updateData) { success in
                   if success {
                       self.showAlert(message: "Profil başarıyla güncellendi!")
                   } else {
                       self.showAlert(message: "Profil güncelleme başarısız.")
                   }
               }
    }
    
    func updatePassword() {
        guard let userId = userId else {
                    showAlert(message: "Kullanıcı kimliği bulunamadı. Lütfen tekrar giriş yapın.")
                    return
                }
                
                let url = URL(string: "https://api.example.com/users/\(userId)/password")!
                
                guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
                    showAlert(message: "Yeni şifreyi girin.")
                    return
                }
                
                let updatedData: [String: Any] = ["password": newPassword]
                
                sendPatchRequest(url: url, data: updatedData) { success in
                    if success {
                        self.showAlert(message: "Şifre başarıyla güncellendi!")
                    } else {
                        self.showAlert(message: "Şifre güncelleme başarısız.")
                    }
                }
        }
        

        func sendPatchRequest(url: URL, data: [String: Any], completion: @escaping (Bool) -> Void) {
            var request = URLRequest(url: url)
                    request.httpMethod = "PATCH"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    do {
                        request.httpBody = try JSONSerialization.data(withJSONObject: data)
                    } catch {
                        print("JSON Serialization error: \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        DispatchQueue.main.async {
                            if let error = error {
                                self.showAlert(message: "Hata oluştu: \(error.localizedDescription)")
                                completion(false)
                                return
                            }
                            
                            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                                completion(true)
                            } else {
                                completion(false)
                            }
                        }
                    }
                    
                    task.resume()
        }
    
    func showAlert(message : String){
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    

}
