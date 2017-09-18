//
//  LoginWithCarytaController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 8/11/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import SwiftyJSON
import Firebase
import Toaster

class LoginWithCarytaController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var dialTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    
    var isFill: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topConst.constant = (self.view.frame.size.height - 50 - 167) / 2
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login(){
        
        let params = [
            "username" : usernameTF.text!,
            "password" : passwordTF.text!
        ]
        
        Alamofire.request("\(link().domain)login", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    if JSON(jason)["status"].stringValue == "1" {
                        
                        print(JSON(jason).description)
                        
                        let token = InstanceID.instanceID().token()!
                        
                        if JSON(jason)["data"]["no_hp"].stringValue == "" {
                            
                            let model = user()
                            
                            model.user_id       = JSON(jason)["data"]["user_id"].stringValue
                            model.first_name    = JSON(jason)["data"]["name"].stringValue
                            model.last_name     = ""
                            model.email         = JSON(jason)["data"]["email"].stringValue
                            model.no_hp         = "\(self.dialTF.placeholder!)\(self.phoneTF.text!)"
                            model.sex           = JSON(jason)["data"]["sex"].stringValue
                            model.avatar        = JSON(jason)["data"]["avatar_small"].stringValue
                            model.registrasi_id = token
                            
                            self.updateToken(user_id: JSON(jason)["data"]["user_id"].stringValue, token: token)
                            
                            DBHelper.insert(obj: model)
                            
                        }else{
                            
                            let model = user()
                            
                            model.user_id       = JSON(jason)["data"]["user_id"].stringValue
                            model.first_name    = JSON(jason)["data"]["name"].stringValue
                            model.last_name     = ""
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
                
        }
        
    }
    
    func updateToken(user_id: String, token: String) {
        
        let params = [
            "userId"        : user_id,
            "registrasiId"  : token
        ]
        
        Alamofire.request("\(link().domainMain)messenger/registrasi-refresh", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    print(JSON(jason).description)
                    
                    if JSON(jason)["status"].stringValue == "1" {
                        
                        self.performSegue(withIdentifier: "segue_main", sender: self)
                        
                    }
                    
                }
                
        }
        
    }
    
    @IBAction func masuk(_ sender: UIButton) {
        
        self.login()
        
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
