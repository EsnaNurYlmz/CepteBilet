//
//  ProfileViewController.swift
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 9.12.2024.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var ProfileCategoryTableView: UITableView!
    let ProfileCategoryList = ["GİRİŞ YAP","PROFİL DÜZENLE","BİLETLERİM","ÇIKIŞ YAP"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileCategoryTableView.dataSource = self
        ProfileCategoryTableView.delegate = self
       
    }


}
extension ProfileViewController: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProfileCategoryTableView.dequeueReusableCell(withIdentifier: "ProfileCategoryCell") as! ProfileCategoryTableViewCell
        cell.ProfileCategoryLabel.text = ProfileCategoryList[indexPath.row]
        return cell
    }
    
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
    */
}
