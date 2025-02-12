//
//  Category.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 4.02.2025.
//

import Foundation

class Category : Codable {
    
    var categoryID : String?
    var categoryName : String?
    var categoryImage : String?
    
    init(){
    }
    
    init(categoryID: String, categoryName: String, categoryImage : String) {
        self.categoryID = categoryID
        self.categoryName = categoryName
        self.categoryImage = categoryImage
    }
    
}
