//
//  MainTabBar.swift
//  AlamofireUserInfo
//
//  Created by user on 11/22/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController {
    
    let alert = Alert()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let vc = viewControllers?[0] {
            selectedViewController = vc
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
    
}
