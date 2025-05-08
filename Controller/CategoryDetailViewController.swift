//
//  CategoryDetailViewController.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 11.12.2024.
//

import UIKit

class CategoryDetailViewController: UIViewController {

   
    @IBOutlet weak var categoryDetailRecommendedCollectionView: UICollectionView!
    @IBOutlet weak var CategoryDetailEventCollectionView: UICollectionView!
    
    
    var events : [Event] = []
    var selectedCategory : Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CategoryDetailEventCollectionView.delegate = self
        CategoryDetailEventCollectionView.dataSource = self
        fetchEvent()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func fetchEvent(){
        guard let category = selectedCategory?.categoryID else { return}
        let urlString = "http://localhost:8080/event/category/\(category)"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data , _, error in
            if let error = error {
                print("Network Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("Error: No data received")
                return
            }
            do {
                let fetchedEvents = try JSONDecoder().decode([Event].self, from: data)
                DispatchQueue.main.async {
                    self.events = fetchedEvents
                    self.CategoryDetailEventCollectionView.reloadData()
                }
            }
            catch {
                print("JSON Decode Error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    @IBAction func FilterButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toDetailFilter", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventDetail",
           let destinationVC = segue.destination as? DetailViewController,
                  let selectedEvent = sender as? Event {
                   destinationVC.eventID = selectedEvent.eventID
               }
    }
}
extension CategoryDetailViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CategoryDetailEventCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryDetailCell", for: indexPath) as! CategoryDetailCollectionViewCell
        let event = events[indexPath.row]
        cell.configure(with : event)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedEvent = events[indexPath.row]
        performSegue(withIdentifier: "toEventDetail", sender: selectedEvent)
    }
    

        
}
