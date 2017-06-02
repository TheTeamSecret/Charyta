//
//  LoginController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 5/29/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import Firebase

class LoginController: UIViewController {

    var username = String()
    
    @IBOutlet weak var passTxt: UITextField!
    
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func masuk(_ sender: UIBarButtonItem) {
        
        let params = [
            "username" : self.username,
            "password" : passTxt.text!
        ]
        
        Alamofire.request("\(link().domain)login", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON{response in
        
                if let jason = response.result.value {
                
                    print(JSON(jason).description)
                    
                    let token = InstanceID.instanceID().token()!
                    
                    let model = user()
                    
                    model.user_id       = JSON(jason)["data"]["user_id"].stringValue
                    model.first_name    = JSON(jason)["data"]["first_name"].stringValue
                    model.last_name     = JSON(jason)["data"]["last_name"].stringValue
                    model.email         = JSON(jason)["data"]["email"].stringValue
                    model.no_hp         = JSON(jason)["data"]["no_hp"].stringValue
                    model.sex           = JSON(jason)["data"]["sex"].stringValue
                    model.avatar        = JSON(jason)["data"]["avatar_small"].stringValue
                    model.registrasi_id = token
                    
                    self.updateToken(user_id: JSON(jason)["data"]["user_id"].stringValue, token: token)
                    
                    DBHelper.insert(obj: model)
                
                }
                
        }
        
    }
    
    func updateToken(user_id: String, token: String) {
        
        let params = [
            "userId"        : user_id,
            "registrasiId"  : token
        ]
        
        Alamofire.request("\(link().domain)registrasi-refresh", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    print(JSON(jason).description)
                    
                    if JSON(jason)["status"].stringValue == "1" {
                        
                        self.performSegue(withIdentifier: "segue_main", sender: self)
                        
                    }
                    
                }
                
        }
        
    }
    
    @IBAction func checkValue(_ sender: UITextField) {
        
        if sender == passTxt {
        
            if passTxt.text!.characters.count > 0 {
            
                self.nextBtn.isEnabled = true
            
            }else{
                
                self.nextBtn.isEnabled = false
                
            }
        
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
