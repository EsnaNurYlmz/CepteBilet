//
//  Event.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 4.02.2025.
//

import Foundation

class Event {
    
    var eventID : String?
    var eventName : String?
    var eventDate : Date?
    var eventLocation : String?
    var eventDetail : String?
    var eventImage : String?
    var eventPrice : String?
    var artistName : String?
    var eventCategory : Category?
    
    init(){
    }
    
    init(eventID: String, eventName: String, eventDate: Date, eventLocation: String, eventDetail: String, eventImage: String, eventPrice: String, artistName: String, eventCategory: Category) {
        self.eventID = eventID
        self.eventName = eventName
        self.eventDate = eventDate
        self.eventLocation = eventLocation
        self.eventDetail = eventDetail
        self.eventImage = eventImage
        self.eventPrice = eventPrice
        self.artistName = artistName
        self.eventCategory = eventCategory
    }
}
