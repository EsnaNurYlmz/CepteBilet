//
//  PaymentViewController.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 27.12.2024.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet weak var cardNumberTextField1: UITextField!
    @IBOutlet weak var cardNumberTextField2: UITextField!
    @IBOutlet weak var cardNumberTextField3: UITextField!
    @IBOutlet weak var cardNumberTextField4: UITextField!
    @IBOutlet weak var cardMonthTextField: UITextField!
    @IBOutlet weak var cardYearTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var termsCheckBox: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var corporateInvoiceCheckBox: UIButton! //kurumsal fatura
    
    var totalAmount: Double = 0.0
    var isTermsAccepted  = false
    var  isCorporateInvoiceSelected = false
    var selectedEvent : Event?
    var userID : String?

    override func viewDidLoad() {
        super.viewDidLoad()

        totalPriceLabel.text = "\(totalAmount) TL"
    }
    
    @IBAction func termsCheckBoxTapped(_ sender: UIButton) {
        isTermsAccepted.toggle()
        let imageName = isTermsAccepted ? "checkmark.square.fill" : "square"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @IBAction func corporateInvoiceCheckBoxTapped(_ sender: UIButton) {
        isCorporateInvoiceSelected.toggle()
        let imageName = isCorporateInvoiceSelected ? "checkmark.square.fill" : "square"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @IBAction func payButtonTapped(_ sender: UIButton) {
        guard isTermsAccepted else {
            showAlert(title: "Uyarı", message: "Ön bilgilendirme koşullarını kabul etmelisiniz.")
            return
        }
        guard let event = selectedEvent , let  userID = userID else{
            showAlert(title: "Hata", message: "Kullanıcı veya etkinlik bilgisi eksik.")
            return
        }
        showAlert(title: "Başarılı!", message: "Ödeme Tamamlandı.")
        self.saveTicketToServer(event: event, userID: userID)
    }
    
    func saveTicketToServer(event : Event , userID : String){
        let ticketData: [String: Any] = [
            "userId": userID,
            "eventId": event.eventID!,
            "eventName": event.eventName!,
            "eventDate": event.eventDate!,
            "eventImage": event.eventImage!,
            "eventLocation": event.eventLocation!,
            "corporateInvoice": isCorporateInvoiceSelected
        ]
        guard let url = URL(string: "https://api.example.com/saveTicket") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ticketData, options: [])
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    self.navigateToTicketsPage()
                    
                }
            }
            else{
                self.showAlert(title: "Hata", message: "Bilet kaydedilemedi!")
            }
        }.resume()
    }
    
    func navigateToTicketsPage() {
        if let ticketsVC = self.storyboard?.instantiateViewController(withIdentifier: "toTicketsViewControlle") as? TicketsViewController {
                self.navigationController?.pushViewController(ticketsVC, animated: true)
            }
        }

    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
        
    }
}
