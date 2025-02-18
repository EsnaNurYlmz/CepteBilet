//
//  Event.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 4.02.2025.
//

import Foundation

class Event : Codable {
    
    let eventID : String?
    let eventName : String?
    let eventDate : String?
    let eventLocation : String?
    let eventType : String?
    let eventImage : String?
    let eventPrice : String?
    let artistName : String?
    var eventCategory : Category?
    var isFavorite: Bool
   
    
    
    init(eventID: String, eventName: String, eventDate: String, eventLocation: String, eventType: String, eventImage: String, eventPrice: String, artistName: String, eventCategory: Category , isFavorite: Bool) {
        self.eventID = eventID
        self.eventName = eventName
        self.eventDate = eventDate
        self.eventLocation = eventLocation
        self.eventType = eventType
        self.eventImage = eventImage
        self.eventPrice = eventPrice
        self.artistName = artistName
        self.eventCategory = eventCategory
        self.isFavorite   = isFavorite
    }
}
