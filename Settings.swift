//
//  Settings.swift
//  AlamofireUserInfo
//
//  Created by user on 11/22/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Settings: UITableViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    let helperAlert = Alert()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        if let name = UserDefaults.standard.value(forKey: "userName"), let email = UserDefaults.standard.value(forKey: "email") {
            
            nameLabel.text = name as? String
            emailLabel.text = email as? String
        }
        if let pic = UserDefaults.standard.value(forKey: "picture") as? String{
            do {
                let image = UIImage(data: try Data(contentsOf: URL(string: pic)!))
            profileImage.image = image
            } catch {
                print("unable To generate Image")
                profileImage.image = #imageLiteral(resourceName: "defaultPerson")
            }
        } else {
            profileImage.image = #imageLiteral(resourceName: "defaultPerson")
        }
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
//        profileImage.layer.cornerRadius = 10;
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signOutTapped(_ Sender: Any) {
        showLogoutAlert()
    }
    
    func showLogoutAlert() {
        
        let alert = UIAlertController(title: "Logging out", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alert: UIAlertAction!) -> Void in
            self.revokeToken()
        }
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func revokeToken() {
        
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        let url = URL(string: "https://accounts.google.com/o/oauth2/revoke?token=\(accessToken!)")!
        Alamofire.request(url,method: .post).responseJSON { response in
            
            if response.result.value != nil {
                UserDefaults.standard.set(nil, forKey: "accessToken")
                UserDefaults.standard.set(nil, forKey: "refreshToken")
                UserDefaults.standard.set(nil, forKey: "userName")
                UserDefaults.standard.set(nil, forKey: "email")
                UserDefaults.standard.set(nil, forKey: "picture")
                self.loginAgain()
            }
        }
        
    }
    func loginAgain() {
        let loginScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
        navigationController?.setViewControllers([loginScreen], animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.isNavigationBarHidden = false
        tabBarController?.navigationItem.title = "Settings"
    }

    
  
}
