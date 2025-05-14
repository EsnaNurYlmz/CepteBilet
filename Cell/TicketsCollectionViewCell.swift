//
//  TicketsCollectionViewCell.swift
//  CepteBilet
//  Created by Esna nur Yılmaz on 17.12.2024.
//

import UIKit

protocol TicketsCollectionViewCellDelegate: AnyObject {
    func didTapCommentButton(for event: Event)
}

class TicketsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    
    weak var delegate: TicketsCollectionViewCellDelegate?
        private var event: Event?
    
    
    func cofigure(with event : Event) {
        self.event = event
        eventNameLabel.text = event.eventName
        eventDateLabel.text = event.eventDate
        eventLocationLabel.text = event.eventLocation
        
        if let imageUrl = URL(string: event.eventImage ?? "") {
            loadImage(for: imageUrl)
            }
        }
    
    func loadImage (for url : URL){
        URLSession.shared.dataTask(with: url) { data , _, error in
            if let error = error{
                print("Görsel Yükleme Hatası: \(error.localizedDescription)")
                return
            }
            if let data = data , let image = UIImage(data: data){
                DispatchQueue.main.async {
                    self.eventImage.image = image
                }
            }
        }.resume()
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        guard let event = event else { return }
        delegate?.didTapCommentButton(for: event)
    }
}
