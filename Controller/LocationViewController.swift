//
//  LocationViewController.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 2.01.2025.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate , UISearchBarDelegate {

    @IBOutlet weak var LocationSearchBar: UISearchBar!
    @IBOutlet weak var MapView: MKMapView!
    
    var eventAddress : String?
    let locationManager = CLLocationManager()
    var userLocation : CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
 
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last {
            userLocation = location.coordinate
            locationManager.stopUpdatingLocation()
            if let adsress = eventAddress{
                geocodeAddressAndOpenMaps(adsress)
            }
                
        }
        
    }
    
    func geocodeAddressAndOpenMaps(_ address : String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address){ (placemarks , error) in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                print("Adres bulunamadı: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                return
         }
            
            let destinationCoordinate = location.coordinate
            self.openAppleMaps(with: destinationCoordinate)
        }
    }
    
    func openAppleMaps(with destinationCoordinate: CLLocationCoordinate2D) {
            guard let userLocation = userLocation else {
                print("Kullanıcı konumu alınamadı.")
                return
            }
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
                
        let userMapItem = MKMapItem(placemark: userPlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            destinationMapItem.name = "Etkinlik Mekanı"
                
        let options: [String: Any] = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                MKMapItem.openMaps(with: [userMapItem, destinationMapItem], launchOptions: options)
            }
}
