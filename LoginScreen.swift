//
//  ViewController.swift
//  UserInformation
//
//  Created by user on 11/22/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SafariServices

class LoginScreen: UIViewController, SFSafariViewControllerDelegate {
    
    
    
    let alert = Alert()
    var safari = SFSafariViewController(url: URL(string: "https://www.google.com")!)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let clientID = "360257128994-5rfki4cdj7knfa2jd0jq19iibqr7g8u6.apps.googleusercontent.com"
        UserDefaults.standard.set(clientID, forKey:"clientID")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        
        let myURL = URL(string: "https://accounts.google.com/o/oauth2/v2/auth?scope=email%20profile%20https://www.googleapis.com/auth/plus.login&response_type=code&redirect_uri=com.example.AlamofireUserInfo:/Oauth2callback&client_id=360257128994-5rfki4cdj7knfa2jd0jq19iibqr7g8u6.apps.googleusercontent.com")
        NotificationCenter.default.addObserver(self, selector: #selector(googleLogin(notification:)), name: Notification.Name("LoginNotification"), object: nil)
        
        safari = SFSafariViewController( url:myURL!)
        safari.delegate = self
        self.present(safari, animated: true, completion: nil)
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("Safari closed before authorization")
        alert.showAlert(title: "Authorization terminated by user", message: "Please try again", vc: self)
    }
    
    @objc func googleLogin(notification: NSNotification) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("LoginNotification"), object: nil)
        
        guard let url = notification.object as? NSURL, let query = url.query else{
            return
        }
        let authorization = query.split(separator: "&")
        let auth = authorization[0].split(separator: "=")
        let authCode = auth[1]
        self.safari.dismiss(animated: true , completion: nil)
        
        if authorization.contains("error=access_denied") {
            alert.showAlert(title: "Access Denied", message: "Authorization Failed. Try Again", vc: self)
        } else {
            generateAccessToken(forAuthorizationCode: String(authCode))
        }
        
        
    }
    
    func generateAccessToken(forAuthorizationCode code:String) {
        
        let parameters : [String:Any] = ["code":code,"redirect_uri":"com.example.AlamofireUserInfo:/Oauth2callback","client_id":"360257128994-5rfki4cdj7knfa2jd0jq19iibqr7g8u6.apps.googleusercontent.com","grant_type":"authorization_code"]
        let urlString = "https://www.googleapis.com/oauth2/v4/token?"
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.queryString)
            .responseJSON { response in
                if response.result.value != nil {
                    let tokenInfo = JSON(response.result.value!)
                    let accessToken = tokenInfo["access_token"].string
                    let refreshToken = tokenInfo["refresh_token"].string
                    UserDefaults.standard.set(accessToken, forKey: "accessToken")
                    UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                    print("\(UserDefaults.standard.value(forKey: "accessToken"))")
                    UserDefaults.standard.synchronize()
                    self.getDetails()
                } else {
                    self.alert.showAlert(title: "Oops! Something went wrong", message: "Please try again", vc: self)
                }
        }
    }
    func getDetails() {
        if let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String {
            print(accessToken)
            
            let url = URL(string:"https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=\(accessToken)")!
            Alamofire.request(url, method: .get).responseJSON { response in
                if response.result.value != nil {
                    let loginUserDetails = JSON(response.result.value!)
                    let name = loginUserDetails["name"].string
                    let email = loginUserDetails["email"].string
                    let profilePicture = loginUserDetails["picture"].string
                    UserDefaults.standard.set(name, forKey: "userName")
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(profilePicture, forKey: "picture")
                    self.goToTabBar()
                } else {
                    self.alert.showAlert(title: "Oops! Something went wrong", message: "Try again", vc: self)
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    func goToTabBar() {
        let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBar")
        navigationController?.setViewControllers([tabBarController], animated: true)
    }
}
