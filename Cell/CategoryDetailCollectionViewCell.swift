//
//  CategoryDetailCollectionViewCell.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 11.12.2024.
//

import UIKit

class CategoryDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryDetailImage: UIImageView!
    @IBOutlet weak var categpryDetailEventName: UILabel!
    @IBOutlet weak var categoryDetailLocation: UILabel!
    @IBOutlet weak var categoryDetailDate: UILabel!
    @IBOutlet weak var categoryDetailType: UILabel!
    @IBOutlet weak var FavoriteButton: UIButton!
    
    var event : Event?
    var isfavorite = false
    
    func configure(with event : Event) {
        self.event = event
        categpryDetailEventName.text = event.eventName
        categoryDetailDate.text = event.eventDate
        categoryDetailType.text = event.eventType
        categoryDetailLocation.text = event.eventLocation
        isfavorite = event.isFavorite
        
        updateFavoriteButton()
        
        if let imageUrl = URL(string: event.eventImage!){
            loadImage(from: imageUrl)
        }
    }
    func updateFavoriteButton() {
            let imageName = isfavorite ? "heart.fill" : "heart"
            FavoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    
    func toggleFavoriteStatus(for event: Event){
        
        guard let eventId = event.eventID else { return }
        let urlString = "https://api.example.com/favorites"
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = isfavorite ? "POST" : "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["event_id": eventId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        URLSession.shared.dataTask(with: request) { data , response , error in
            if let error = error {
            print("Favorite Error: \(error.localizedDescription)")
                return
            }
            print(self.isfavorite ? "Event added to favorites" : "Event removed from favorites")
        }.resume()
    }
    
    func loadImage(from url: URL) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    print("Image Load Error: \(error.localizedDescription)")
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.categoryDetailImage.image = image
                    }
                }
            }.resume()
        }
    
    
    @IBAction func FavoriteButton(_ sender: UIButton) {
        guard let event = event else {return}
        isfavorite.toggle()
        updateFavoriteButton()
        toggleFavoriteStatus(for: event)
    }
    
}
