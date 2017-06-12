//
//  LoginWithStoreController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/3/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import Firebase
import Toaster

class LoginWithStoreController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var noPhone: UITextField!
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    @IBOutlet weak var nomorTeleponValue: UIView!
    
    var isFill: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkValue(_ sender: UITextField) {
        
        if sender == noPhone {
            
            if username.text!.characters.count > 0 {
                
                self.isFill = true
                self.nextBtn.isEnabled = true
                
            }else{
                
                self.isFill = false
                self.nextBtn.isEnabled = false
                
            }
        
        }
            
        if username.text!.characters.count > 0 && password.text!.characters.count > 0 {
            
            self.nextBtn.isEnabled = true
            
        }else{
            
            self.nextBtn.isEnabled = false
            
        }
        
    }
    
    @IBAction func login(_ sender: UIBarButtonItem) {
        
        login()
        
    }
    
    func login(){
        
        let params = [
            "username" : username.text!,
            "password" : password.text!
        ]
        
        Alamofire.request("\(link().domain)login", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    if JSON(jason)["status"].stringValue == "1" {
                        
                        print(JSON(jason).description)
                        
                        let token = InstanceID.instanceID().token()!
                        
                        if JSON(jason)["data"]["no_hp"].stringValue == "" {
                            
                            if self.isFill == true {
                                
                                let model = user()
                                
                                model.user_id       = JSON(jason)["data"]["user_id"].stringValue
                                model.first_name    = JSON(jason)["data"]["name"].stringValue
                                model.last_name     = ""
                                model.email         = JSON(jason)["data"]["email"].stringValue
                                model.no_hp         = self.noPhone.text!
                                model.sex           = JSON(jason)["data"]["sex"].stringValue
                                model.avatar        = JSON(jason)["data"]["avatar_small"].stringValue
                                model.registrasi_id = token
                                
                                self.updateToken(user_id: JSON(jason)["data"]["user_id"].stringValue, token: token)
                                
                                DBHelper.insert(obj: model)
                            
                            }
                            
                            if self.isFill == false {
                                
                                self.nomorTeleponValue.isHidden = false
                                self.nextBtn.isEnabled = false
                                
                            }
                        
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
                        
                    }else{
                        
                        self.login0()
                        
                    }
                    
                }
                
        }
        
    }
    
    func login0(){
        
        let params = [
            "username" : username.text!,
            "password" : password.text!
        ]
        
        Alamofire.request("\(link().domain)login", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    if JSON(jason)["status"].stringValue == "1" {
                        
                        print(JSON(jason).description)
                        
                        let token = InstanceID.instanceID().token()!
                        
                        if JSON(jason)["data"]["no_hp"].stringValue == "" {
                            
                            if self.isFill == true {
                                
                                let model = user()
                                
                                model.user_id       = JSON(jason)["data"]["user_id"].stringValue
                                model.first_name    = JSON(jason)["data"]["name"].stringValue
                                model.last_name     = ""
                                model.email         = JSON(jason)["data"]["email"].stringValue
                                model.no_hp         = self.noPhone.text!
                                model.sex           = JSON(jason)["data"]["sex"].stringValue
                                model.avatar        = JSON(jason)["data"]["avatar_small"].stringValue
                                model.registrasi_id = token
                                
                                self.updateToken(user_id: JSON(jason)["data"]["user_id"].stringValue, token: token)
                                
                                DBHelper.insert(obj: model)
                                
                            }
                            
                            if self.isFill == false {
                                
                                self.nomorTeleponValue.isHidden = false
                                self.nextBtn.isEnabled = false
                                
                            }
                            
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
                        
                    }else{
                        
                        self.loginCode()
                        
                    }
                    
                }
                
        }
        
    }
    
    func loginCode(){
        
        let params = [
            "username" : username.text!,
            "password" : password.text!
        ]
        
        Alamofire.request("\(link().domain)login", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    if JSON(jason)["status"].stringValue == "1" {
                        
                        print(JSON(jason).description)
                        
                        let token = InstanceID.instanceID().token()!
                        
                        if JSON(jason)["data"]["no_hp"].stringValue == "" {
                            
                            if self.isFill == true {
                                
                                let model = user()
                                
                                model.user_id       = JSON(jason)["data"]["user_id"].stringValue
                                model.first_name    = JSON(jason)["data"]["name"].stringValue
                                model.last_name     = ""
                                model.email         = JSON(jason)["data"]["email"].stringValue
                                model.no_hp         = self.noPhone.text!
                                model.sex           = JSON(jason)["data"]["sex"].stringValue
                                model.avatar        = JSON(jason)["data"]["avatar_small"].stringValue
                                model.registrasi_id = token
                                
                                self.updateToken(user_id: JSON(jason)["data"]["user_id"].stringValue, token: token)
                                
                                DBHelper.insert(obj: model)
                                
                            }
                            
                            if self.isFill == false {
                                
                                self.nomorTeleponValue.isHidden = false
                                self.nextBtn.isEnabled = false
                                
                            }
                            
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
                        
                    }else{
                        
                        self.loginPlusCode()
                        
                    }
                    
                }
                
        }
        
    }
    
    func loginPlusCode(){
        
        let params = [
            "username" : username.text!,
            "password" : password.text!
        ]
        
        Alamofire.request("\(link().domain)login", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    if JSON(jason)["status"].stringValue == "1" {
                        
                        print(JSON(jason).description)
                        
                        let token = InstanceID.instanceID().token()!
                        
                        if JSON(jason)["data"]["no_hp"].stringValue == "" {
                            
                            if self.isFill == true {
                                
                                let model = user()
                                
                                model.user_id       = JSON(jason)["data"]["user_id"].stringValue
                                model.first_name    = JSON(jason)["data"]["name"].stringValue
                                model.last_name     = ""
                                model.email         = JSON(jason)["data"]["email"].stringValue
                                model.no_hp         = self.noPhone.text!
                                model.sex           = JSON(jason)["data"]["sex"].stringValue
                                model.avatar        = JSON(jason)["data"]["avatar_small"].stringValue
                                model.registrasi_id = token
                                
                                self.updateToken(user_id: JSON(jason)["data"]["user_id"].stringValue, token: token)
                                
                                DBHelper.insert(obj: model)
                                
                            }
                            
                            if self.isFill == false {
                                
                                self.nomorTeleponValue.isHidden = false
                                self.nextBtn.isEnabled = false
                                
                            }
                            
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
                        
                    }else{
                        
                        Toast.init(text: "Password salah!").show()
                        
                    }
                    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
