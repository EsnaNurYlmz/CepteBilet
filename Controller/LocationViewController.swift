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
    @IBOutlet weak var routeButton: UIButton!
    
    var eventAddress : String?
    let locationManager = CLLocationManager()
    var userLocation : CLLocationCoordinate2D?
    var searchedCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hidesBottomBarWhenPushed = false
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        MapView.delegate = self
        LocationSearchBar.delegate = self
    }
    
    @IBAction func routeButtonTapped(_ sender: UIButton) {
            guard let destinationCoordinate = searchedCoordinate else {
                print("Henüz arama yapılmadı veya konum bulunamadı.")
                return
            }
            openAppleMaps(with: destinationCoordinate)
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchBar.resignFirstResponder()  // Klavyeyi kapat
        geocodeAddressFromSearchBar(searchText)
    }
    func geocodeAddressFromSearchBar(_ address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Adres aranırken hata: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first, let location = placemark.location else {
                print("Adres bulunamadı.")
                return
            }
            
            let coordinate = location.coordinate
            self.searchedCoordinate = coordinate  // Sonraki adım için kaydediyoruz
            
            // Haritada pin göster
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Aranan Konum"
            self.MapView.removeAnnotations(self.MapView.annotations)
            self.MapView.addAnnotation(annotation)
            
            // Harita konumuna odaklan
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.MapView.setRegion(region, animated: true)
        }
    }

}
