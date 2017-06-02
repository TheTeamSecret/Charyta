//
//  SplashScreenController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/1/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import RealmSwift

class SplashScreenController: UIViewController {
    
    let getUser = try! Realm().objects(user.self)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if getUser.count > 0 {
            
            self.performSegue(withIdentifier: "segue_main", sender: self)
            
        }else if getUser.count == 0 {
            
            self.performSegue(withIdentifier: "segue_first", sender: self)
            
        }
        
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
