//
//  TicketsViewController.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 16.12.2024.
//

import UIKit

class TicketsViewController: UIViewController {

    @IBOutlet weak var TicketCollectionView: UICollectionView!
    
    var purchasedTickets : [Event] = [] //satın alınan biletlerin saklanacağı dizi
    var userID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TicketCollectionView.delegate = self
        TicketCollectionView.dataSource = self
        fetchPurchasedTickets()

    }
    
    func fetchPurchasedTickets() {
        
        guard let userID = userID else { return }
        guard let url = URL(string: "https://api.example.com/getTickets?userId=\(userID)") else { return }
        
        URLSession.shared.dataTask(with: url) { data , response , error in
            guard let data = data , error == nil else { return }
            let decodedResponse = try? JSONDecoder().decode([Event].self, from: data)
                       if let tickets = decodedResponse {
                           DispatchQueue.main.async {
                               self.purchasedTickets = tickets
                               self.TicketCollectionView.reloadData()
                           }
                       }
        }.resume()
    }
}

extension TicketsViewController : UICollectionViewDelegate , UICollectionViewDataSource , TicketsCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return purchasedTickets.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TicketsCell", for: indexPath) as! TicketsCollectionViewCell
        let ticket = purchasedTickets[indexPath.row]
        cell.cofigure(with: ticket)
        cell.delegate = self
        return cell
    }
    func didTapCommentButton(for event: Event) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let commentVC = storyboard.instantiateViewController(withIdentifier: "CommentViewController") as? ReviewViewController {
            commentVC.eventID = event.eventID
            navigationController?.pushViewController(commentVC, animated: true)
        }
    }

    
}
