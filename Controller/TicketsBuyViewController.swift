//
//  TicketsBuyViewController.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 26.12.2024.
//

import UIKit

class TicketsBuyViewController: UIViewController {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var ticketPriceLabel: UILabel!
    @IBOutlet weak var serviceFeeLabel: UILabel! //Hizmet Bedeli
    @IBOutlet weak var totalPriceLabel: UILabel! //Toplam Bilet fiyatı
    @IBOutlet weak var ticketCountLabel: UILabel! // kişi sayısı
    @IBOutlet weak var plusTicketCountButton: UIButton!
    @IBOutlet weak var minusTicketCountButton: UIButton!
    
    var event : Event?
    var ticketCount : Int = 1
    var serviceFee : Double = 2.90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let event = event {
                    updateUI(with: event)
        }
    }
    
    func updateUI(with event : Event){
        
        eventNameLabel.text = event.eventName
        eventDateLabel.text = event.eventDate
        artistNameLabel.text = event.artistName
        serviceFeeLabel.text = String(format: "%.2f TL", serviceFee)

        
        if let priceString = event.eventPrice, let price = Double(priceString) {
                   ticketPriceLabel.text = String(format: "%.2f TL", price)
                   updateTotalPrice()
               }
        if let imageUrl = event.eventImage, let url = URL(string: imageUrl) {
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.eventImage.image = image
                            }
                        }
                    }
                }
    }
    func updateTotalPrice() {
            if let priceString = event?.eventPrice,
               let price = Double(priceString) {
                let total = Double(ticketCount) * price + serviceFee
                totalPriceLabel.text = String(format: "%.2f TL", total)
                ticketCountLabel.text = "\(ticketCount)"
            }
        }

    @IBAction func PlusCountButton(_ sender: UIButton) {
        ticketCount += 1
        updateTotalPrice()
    }
    
    @IBAction func MinusCountButton(_ sender: UIButton) {
        if ticketCount > 1 {
            ticketCount -= 1
            updateTotalPrice()
        }
    }
    
    @IBAction func proceedToPayment(_ sender: UIButton) {
        performSegue(withIdentifier: "toPaymentVC", sender: nil)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPaymentVC",
           let paymentVC = segue.destination as? PaymentViewController {
            
            let totalPriceText = totalPriceLabel.text?.replacingOccurrences(of: " TL", with: "") ?? "0"
            let totalPriceDouble = Double(totalPriceText) ?? 0.0
            paymentVC.totalAmount = totalPriceDouble
        }
    }

}
