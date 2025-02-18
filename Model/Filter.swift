//
//  Filter.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 4.02.2025.
//

import Foundation

class Filter : Codable{
    
    var city : String?
    var location : String?
    var date : String?
    var filterCategory : Category?
    
    init(){
    }
    
    init(city: String, location: String, date: String, filterCategory: Category) {
        self.city = city
        self.location = location
        self.date = date
        self.filterCategory = filterCategory
    }
}
