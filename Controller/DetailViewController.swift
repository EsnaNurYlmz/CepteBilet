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
       checkIfFavorite()
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
                print(String(data: data, encoding: .utf8) ?? "Veri okunamadı")
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
    func checkIfFavorite() {
        guard let userId = SessionManager.shared.userId,
              let eventId = event?.eventID else { return }

        let urlString = "http://localhost:8080/favorites/check?userId=\(userId)&eventId=\(eventId)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            let isFavorite = String(data: data, encoding: .utf8) == "true"
            DispatchQueue.main.async {
                let heartImage = isFavorite ? "heart.fill" : "heart"
                self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: heartImage)
                self.navigationItem.rightBarButtonItem?.tintColor = isFavorite ? .red : .black
            }
        }.resume()
    }
    
    //kullanıcı arayüzü güncelleme
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
       performSegue(withIdentifier: "toTicketsBuy", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toTicketsBuy",
               let destinationVC = segue.destination as? TicketsBuyViewController,
               let event = self.event {
                destinationVC.event = event
            }
        }
    
    @IBAction func favoriteClicked(_ sender: UIBarButtonItem) {
            guard let userId = SessionManager.shared.userId,
                  let eventId = event?.eventID else {
                print("Kullanıcı ID veya Etkinlik ID eksik")
                return
            }

            let urlString = "http://localhost:8080/favorites"
            guard let url = URL(string: urlString) else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let favoriteData: [String: Any] = [
                "userId": userId,
                "eventId": eventId
            ]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: favoriteData, options: [])
            } catch {
                print("JSON encode hatası: \(error.localizedDescription)")
                return
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Favori ekleme hatası: \(error.localizedDescription)")
                    return
                }

                DispatchQueue.main.async {
                    sender.tintColor = .red 
                    sender.image = UIImage(systemName: "heart.fill")
                }
            }.resume()
        }
    
    @IBAction func locationClicked(_ sender: UIBarButtonItem) {
        guard let address = locationLabel.text else { return }
            
            let Address = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if let url = URL(string: "http://maps.apple.com/?q=\(Address)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
    }
    
    
    
}
