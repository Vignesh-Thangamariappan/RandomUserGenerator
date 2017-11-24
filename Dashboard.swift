//
//  Dashboard.swift
//  AlamofireUserInfo
//
//  Created by user on 11/22/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Dashboard: UITableViewController {
    
    let alert = Alert()
    var user = [String]()
    var userImage = [UIImage]()
    var email = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UserInfo")
        cell.imageView?.image = userImage[indexPath.row]
        cell.imageView?.layer.cornerRadius = userImage[indexPath.row].size.width/2
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = user[indexPath.row]
        cell.detailTextLabel?.text = email[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return user.count
    }
    @IBAction func addTapped(_ sender: Any) {
        alert.showLoader(self: self)
        getRandomUser()
        
    }

    
    func getRandomUser() {
        
        Alamofire.request("https://randomuser.me/api/").responseJSON { response in
            if response.result.value != nil {
                let userDetails = JSON(response.result.value!)["results"]
                let name = "\(userDetails[0]["name"]["first"]) \(userDetails[0]["name"]["last"])"
                let mail = "\(userDetails[0]["email"])"
                let pic = "\(userDetails[0]["picture"]["medium"])"
                print(pic)
                do {
                let pict = UIImage(data: try Data(contentsOf: URL(string: pic)!))!
                    self.userImage.append(pict)
                } catch { print("Unable to generate image")
                    self.userImage.append(#imageLiteral(resourceName: "defaultPerson"))
                }
                self.user.append(name)
                self.email.append(mail)
                
                self.addRow()
            }
        }
    }
    func addRow() {
        let indexPath = IndexPath(row: user.count-1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        alert.dismissLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.isNavigationBarHidden = true
    }
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }    
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
