//
//  SignUpViewController.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 9.12.2024.
//

import UIKit

class SignUpViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var CheckBox: UIButton!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    var isTermsAccepted = false
    let countryCode = ["+1 (Kanada)", "+44 (Birleşik Krallık)", "+49 (Almanya)", "+90 (Türkiye)","+61 (Avustralya)", "+994 (Azerbaycan)", "+32 (Belçika)", "+55 (Brezilya)","+45 (Danimarka)", "+62 (Endonezya)", "+33 (Fransa)", "+27 (Güney Afrika)","+91 (Hindistan)","+34 (İspanya)", "+46 (İşveç)", "+41 (İşviçre)", "+39 (İtalya)","+57 (Kolombiya)","+53 (Küba)", "+36 (Macaristan)", "+52 (Meksika)", "+20 (Mısır)","+47 (Norveç)","+48 (Polonya)", "+351 (Portekiz)", "+40 (Romanya)", "+66 (Tanzanya)","+84 (Vietnam)"]
    let genderType = ["Kadın","Erkek","Belirsiz"]
    
    let countryPicker = UIPickerView()
    let genderPicker = UIPickerView()
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryPicker.delegate = self
        countryPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        countryCodeTextField.inputView = countryPicker
        genderTextField.inputView = genderPicker
        
        segmentedController.selectedSegmentIndex = 1
        
        setupDatePicker()
        setupTapGesture()
        styleTextFields()
    }
    
    func styleTextFields() {
        let textFields = [nameTextField, surnameTextField, emailTextField, passwordTextField, countryCodeTextField, phoneTextField, birthDateTextField, genderTextField]
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
    
    func setupDatePicker () {
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels // iOS 14 ve sonrası için stil ayarlandı.
        }
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        birthDateTextField.inputView = datePicker
    }
    
    @objc func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        birthDateTextField.text = formatter.string(from: datePicker.date)
        }
    func setupTapGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
            view.addGestureRecognizer(tapGesture)
        }

    @objc func dismissPicker() {
            view.endEditing(true) // Aktif olan picker veya klavyeyi kapatır.
        }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPicker{
            return countryCode.count
        }
        else{
            return genderType.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == countryPicker{
            return countryCode[row]
        }
        else{
            return genderType[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryPicker{
            let fullCode = countryCode[row]
                    let codeOnly = fullCode.components(separatedBy: " ").first ?? ""
                    countryCodeTextField.text = codeOnly
        }
        else{
            genderTextField.text = genderType[row]
            genderTextField.resignFirstResponder()
        }
    }

    @IBAction func chechBoxTapped(_ sender: UIButton) {
        isTermsAccepted.toggle()
        let imageName = isTermsAccepted ? "checkmark.square.fill" : "square"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        
        if isTermsAccepted {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let privacyVC = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as? PrivacyPolicyViewController {
                    if let sheet = privacyVC.sheetPresentationController {
                        sheet.detents = [.medium(), .large()] // Yarım sayfa açılacak ve kaydırılabilir olacak
                        sheet.prefersGrabberVisible = true    // Kullanıcının aşağı çekmesi için tutmaç görünür olacak
                        sheet.preferredCornerRadius = 20      // Köşeler yuvarlatılacak
                    }
                    present(privacyVC, animated: true, completion: nil)
                }
            }
    }
  
    @IBAction func signUpTapped(_ sender: UIButton) {
        guard  let name = nameTextField.text, !name.isEmpty,
               let surname = surnameTextField.text, !surname.isEmpty,
               let email = emailTextField.text, !email.isEmpty,
               let password = passwordTextField.text, !password.isEmpty,
               let phone = phoneTextField.text, !phone.isEmpty,
               let countryCode = countryCodeTextField.text, !countryCode.isEmpty,
               let gender = genderTextField.text, !gender.isEmpty,
               let birthDate = birthDateTextField.text, !birthDate.isEmpty else{
            showAlert(message: "Lütfen tüm alanları doldurunuz!")
            return
        }
        if !isTermsAccepted {
                    showAlert(message: "Üyeliği tamamlamak için kişisel verilerin korunması şartını kabul etmelisiniz!")
                    return
                }
        let user = User(userID: UUID().uuidString, userName: name, userSurname: surname, userEmail: email, userPassword: password, countryCode: countryCode, userPhoneNumber: phone, userGender: gender, userBirthDate: datePicker.date)
         registerUser(user : user)
        
        showAlert(message: "Üyeliğiniz başarıyla tamamlandı. Hoş geldiniz!")
       
    }
    func showAlert(message: String) {
           let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Tamam", style: .default))
           present(alert, animated: true)
       }
       
    
    func registerUser (user : User) {
        let url = URL(string: "https://your-api-endpoint.com/register")!
        
        var request = URLRequest(url : url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
                    "name": user.userName ?? "",
                    "surname": user.userSurname ?? "",
                    "email": user.userEmail ?? "",
                    "password": user.userPassword ?? "",
                    "phone": user.userPhoneNumber ?? "",
                    "countryCode": user.userID ?? "",
                    "gender": user.userGender ?? "",
                    "birthDate": ISO8601DateFormatter().string(from: user.userBirthDate ?? Date())
                ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { data , response , error in
            if let error = error {
            print("Error: \(error.localizedDescription)") // Hata varsa yazdırılır.
            return
            }
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)") // API yanıtı yazdırılır.
            }
        }.resume()
    }
    
    @IBAction func segmentedController(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                        loginVC.modalPresentationStyle = .fullScreen
                        present(loginVC, animated: true, completion: nil)
                    }
                }
    }
    
   
}
