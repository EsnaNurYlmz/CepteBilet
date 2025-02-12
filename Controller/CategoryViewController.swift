//
//  CategoryViewController.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 11.12.2024.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var CategorySearchBar: UISearchBar!
    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    
    var categories : [Category] = []
    var filteredCategories : [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        CategoryCollectionView.delegate = self
        CategoryCollectionView.dataSource  = self
        CategorySearchBar.delegate = self
        fetchCategories()
    }
    
    func fetchCategories(){
        let urlString  = " htpp:/...."
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { data , _, error in
            guard let data = data, error == nil else { return }
            let categories = try? JSONDecoder().decode([Category].self, from: data)
            
            DispatchQueue.main.async {
                self.categories = categories ?? []
                self.filteredCategories = self.categories
                self.CategoryCollectionView.reloadData()
                
            }
        }.resume()
    }
}
extension CategoryViewController :  UICollectionViewDelegate , UICollectionViewDataSource , UISearchBarDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        let category = filteredCategories[indexPath.row]
        cell.getCategory(with: category)
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCategories = categories
        }else{
            filteredCategories = categories.filter { $0.categoryName!.lowercased().contains(searchText.lowercased()) }
        }
        CategoryCollectionView.reloadData()
    }
}

