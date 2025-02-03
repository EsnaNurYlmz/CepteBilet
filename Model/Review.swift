//
//  Review.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 4.02.2025.
//

import Foundation

class Review {
    
    var reviewID: String?
    var eventID : Event?
    var userID : User?
    var review : String?
    var reviewPoint : String?
    
    init(){
    }
    
    init(reviewID: String, eventID: Event, userID: User, review: String, reviewPoint: String) {
        self.reviewID = reviewID
        self.eventID = eventID
        self.userID = userID
        self.review = review
        self.reviewPoint = reviewPoint
    }
}
