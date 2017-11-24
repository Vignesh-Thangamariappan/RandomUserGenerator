//
//  MainNavigationVCViewController.swift
//  AlamofireUserInfo
//
//  Created by user on 11/23/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainNavigation: UINavigationController {
    
    let loginScreen = LoginScreen()
    let alert = Alert()
    override func viewDidLoad() {
        super.viewDidLoad()
        let accessToken = UserDefaults.standard.value(forKey: "accessToken")
        let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
        let tabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBar")
        if accessToken == nil {
            setViewControllers([login], animated: true)
        } else {
            checkValidity(forToken: accessToken as! String)
            setViewControllers([tabBar], animated: true)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func checkValidity(forToken accessToken:String) {
        
            let url = URL(string:"https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=\(accessToken)")!
            
            Alamofire.request(url).responseJSON { response in
                if response.result.value != nil {
                    print(JSON(response.result.value!))
                    self.loginScreen.getDetails()
                }
                else {
                    self.refreshToken()
                }
            }
        }
    
    func refreshToken() {
        if let refreshToken = UserDefaults.standard.value(forKey: "refreshToken") as? String,let clientID = UserDefaults.standard.value(forKey: "clientID") as? String {
            let url = URL(string:"https://www.googleapis.com/oauth2/v4/token?")!
            let parameter:[String:Any] = ["client_id":"\(clientID)","refresh_token":"\(refreshToken)","grant_type":"refresh_token"]
            Alamofire.request(url, method: .post, parameters: parameter, encoding: URLEncoding.queryString).responseJSON {response in
                if response.result.value != nil {
                    let tokenInfo = JSON(response.result.value!)
                    let accessToken = tokenInfo["access_token"].string
                    UserDefaults.standard.set(accessToken, forKey:"accessToken")
                    self.loginScreen.getDetails()
                }
                else {
                    self.loginAgain()
                }
        }
        
    }
}
    

        func errorOccured() {
            alert.showAlert(title: "Oops! Something went wrong", message: "Please try again", vc: self)
        }
        func errorTokenExpired() {
            alert.showAlert(title: "Oops! Token Expired", message: "Please login again", vc: self)
        }
        func loginAgain() {
            errorTokenExpired()
            let loginScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
           navigationController?.setViewControllers([loginScreen], animated: true)
        }
    
}
