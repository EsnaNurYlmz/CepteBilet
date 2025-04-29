//
//  DetailViewController.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 11.12.2024.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var eventDetailTextView: UITextView!
    
    var eventID: String?
    var event : Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventDetailTextView.isEditable = false
        eventDetailTextView.isScrollEnabled = true
        if let eventID = eventID {
            fetchEventDetails(eventID: eventID)
        }
    }
    
    func fetchEventDetails(eventID : String) {
        let urlString = "http://localhost:8080/event/category/\(eventID)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data , _, error  in
            
            if let error = error {
                print("Bağlantı Hatası!: \(error.localizedDescription)")
            }
            guard let  data = data else {
                print("Error: Boş yanıt alındı!")
                return
            }
            do {
                            let eventDetails = try JSONDecoder().decode(Event.self, from: data)
                            DispatchQueue.main.async {
                                self.event = eventDetails
                                self.updateUI()
                            }
                        } catch {
                            print("JSON Decode Error: \(error.localizedDescription)")
                        }
        }.resume()
    }
    
    func updateUI() {
        
        guard let event = event  else { return }
        
        eventNameLabel.text = event.eventName
        artistNameLabel.text = event.artistName
        locationLabel.text = event.eventLocation
        eventDetailTextView.text = event.eventType
        
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
    @IBAction func TicketBuyButton(_ sender: Any) {
    }
    
}
