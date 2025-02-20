//
//  FavoriteCollectionViewCell.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 16.12.2024.
//
protocol FavoriteCollectionViewCellDelegate: AnyObject {
    func didTapBuyTicket(event: Event)
}
import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var favoriteEventImage: UIImageView!
    @IBOutlet weak var favoriteEventName: UILabel!
    @IBOutlet weak var favoriteEventDate: UILabel!
    @IBOutlet weak var favoriteEventLocation: UILabel!
    @IBOutlet weak var TicketBuyButton: UIButton!
    var event : Event?
    weak var delegate: FavoriteCollectionViewCellDelegate?
    
    func configure(with event : Event) {
        self.event = event
        favoriteEventName.text = event.eventName
        favoriteEventDate.text = event.eventDate
        favoriteEventLocation.text = event.eventLocation
        
        if let imageUrl = URL(string: event.eventImage ?? "") {
            loadImage(for: imageUrl)
            }
        
        func loadImage (for url : URL){
            
            URLSession.shared.dataTask(with: url) { data , _, error in
                if let error = error{
                    print("Görsel Yükleme Hatası: \(error.localizedDescription)")
                    return
                }
                if let data = data , let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self.favoriteEventImage.image = image
                    }
                }
            }.resume()
        }
    }
    @IBAction func TicketButton(_ sender: UIButton) {
        guard let event = event else { return }
                delegate?.didTapBuyTicket(event: event)
    }
    
}
