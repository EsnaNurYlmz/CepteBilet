//
//  Category.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 4.02.2025.
//

import Foundation

class Category {
    
    var categoryID : String?
    var categoryName : String?
    
    init(){
    }
    
    init(categoryID: String, categoryName: String) {
        self.categoryID = categoryID
        self.categoryName = categoryName
    }
    
}
