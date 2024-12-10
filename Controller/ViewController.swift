//
//  ViewController.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 9.12.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var advertCollectionView: UICollectionView!
    let advert = ["advert2","advert1","advert3","advert4","advert6","advert5","advert7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        advertCollectionView.delegate = self
        advertCollectionView.dataSource = self
    }


}
extension ViewController: UICollectionViewDelegate , UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == advertCollectionView {
            return advert.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == advertCollectionView {
            let cell = advertCollectionView.dequeueReusableCell(withReuseIdentifier: "AdvertCell", for: indexPath) as! HomePageAdvertCollectionViewCell
            cell.advertImage.image = UIImage(named: advert[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
}
