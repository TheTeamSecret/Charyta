//
//  MenuBarController.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/16/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class MenuBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarStyle(.lightContent)
        
        tabBar.items![0].selectedImage = UIImage.init(named: "selected_telepon")
        tabBar.items![1].selectedImage = UIImage.init(named: "selected_chat")
        tabBar.items![2].selectedImage = UIImage.init(named: "selected_news")
        tabBar.items![3].selectedImage = UIImage.init(named: "selected_kontak")
        tabBar.items![4].selectedImage = UIImage.init(named: "selected_setting")

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
