//
//  ReviewViewController.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 18.12.2024.
//

import UIKit

class ReviewViewController: UIViewController {

    
    
    
    var eventID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let eventID = eventID {
                    print("Yorum yapılacak etkinlik ID: \(eventID)")
        }
    }
    

    

}
