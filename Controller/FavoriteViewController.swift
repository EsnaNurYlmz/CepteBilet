//
//  FavoriteViewController.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 16.12.2024.
//

import UIKit

class FavoriteViewController: UIViewController, FavoriteCollectionViewCellDelegate {
   
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    var favoriteEvent : [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        fetchFavoriteEvents()
        
    }
    
    func fetchFavoriteEvents() {
        guard let userId = SessionManager.shared.userId else {
            print("Kullanıcı ID bulunamadı")
            return
        }
        
        let urlString = "https://api.example.com/favorites/user/\(userId)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Ağ Hatası: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("Veri alınamadı")
                return
            }
            do {
                let favorites = try JSONDecoder().decode([Event].self, from: data)
                DispatchQueue.main.async {
                    self.favoriteEvent = favorites
                    self.favoriteCollectionView.reloadData()
                }
            } catch {
                print("JSON Çözümleme Hatası: \(error.localizedDescription)")
            }
        }.resume()
    }

    func didTapBuyTicket(event: Event) {
        performSegue(withIdentifier: "toFavoriteBuyTicket", sender: event)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFavoriteBuyTicket",
           let destinationVC = segue.destination as? TicketsBuyViewController,
           let event = sender as? Event {
            destinationVC.event = event // event aktarıldı
        }
    }
}
extension FavoriteViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteEvent.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCollectionViewCell
        let event = favoriteEvent[indexPath.row]
        cell.configure(with: event)
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, trailingSwipeActionsConfigurationForItemAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { _, _, completionHandler in
                let event = self.favoriteEvent[indexPath.row]
                self.removeFromFavorites(event: event)
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .red
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }

    func removeFromFavorites(event : Event) {
        
        let urlString = "https://api.example.com/favorites/\(event.eventID!)"
        guard let url = URL(string: urlString) else {return}
        
        var reguest = URLRequest(url: url)
        reguest.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: reguest) { _ , _, error in
            if let error = error {
                print("Favoriden çıkarma hatası: \(error.localizedDescription)")
            }
            else{
                print("Favoriden çıkarıldı!")
                DispatchQueue.main.async {
                    self.fetchFavoriteEvents()
                }
            }
        }.resume()
    }
}
