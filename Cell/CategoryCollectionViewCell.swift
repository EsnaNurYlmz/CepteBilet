//
//  CategoryCollectionViewCell.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 11.12.2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var CategoryImage: UIImageView!
    @IBOutlet weak var CategoryLabel: UILabel!
    
    func getCategory(with category : Category) {
        CategoryLabel.text = category.categoryName
        loadImage(from: category.categoryImage!)
    }
    
    func loadImage(from urlString : String){
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.CategoryImage.image = UIImage(data: data)
                }
            }
        }
    }
}
