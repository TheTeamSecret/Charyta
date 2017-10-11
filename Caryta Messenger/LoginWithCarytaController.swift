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
        let url = "\(link().subDomain)auth/login"
        let head = [
            "Content-Type" : "application/json"
        ]
        let params = [
            "username" : self.usernameTF.text!,
            "password" : self.passwordTF.text!
        ]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: head)
            .responseJSON {response in
                if let jason = response.result.value {
                    print(jason)
                    let token = InstanceID.instanceID().token()!
                    let data = JSON(jason)["user"]
                    //if JSON(jason)["data"]["no_hp"].stringValue == "" {
                        //Yang sebelumnya
//                        let model = user()
//                        model.user_id       = JSON(jason)["data"]["user_id"].stringValue
//                        model.first_name    = JSON(jason)["data"]["name"].stringValue
//                        model.last_name     = ""
//                        model.email         = JSON(jason)["data"]["email"].stringValue
//                        model.no_hp         = "\(self.dialTF.placeholder!)\(self.phoneTF.text!)"
//                        model.sex           = JSON(jason)["data"]["sex"].stringValue
//                        model.avatar        = JSON(jason)["data"]["avatar_small"].stringValue
//                        model.registrasi_id = token
//                        self.updateToken(JSON(jason)["data"]["user_id"].stringValue, token: token)
//                        DBHelper.insert(obj: model)
//                    }else{
                        //Yg Sekarang
                        let model = user()
                        model.user_id       = data["kode_user"].stringValue
                        model.first_name    = data["nama_depan"].stringValue
                        model.last_name     = data["nama_belakang"].stringValue
                        model.email         = data["email"].stringValue
                        model.no_hp         = data["telepon"].stringValue
                        model.sex           = data["jk"].stringValue
                        model.avatar        = data["gambar"].stringValue
                        model.registrasi_id = token
                        DBHelper.insert(obj: model)
                        self.updateToken(data["kode_user"].stringValue, token: token)
                    //}
                }else{
                    print("Request Gagal")
                }
        }
    }
    
    func updateToken(_ user_id: String, token: String) {
        let params = [
            "kodeUser"       : user_id,
            "firebaseToken"  : token
        ]
        let head = [
            "Content-Type" : "application/json"
        ]
        Alamofire.request("\(link().subDomain)auth/register-refresh", method: .post, parameters: params, encoding: JSONEncoding.default, headers: head)
            .responseJSON{response in
                if let jason = response.result.value {
                    print(JSON(jason).description)
                    if JSON(jason)["status"].stringValue == "1" {
                        self.performSegue(withIdentifier: "segue_main", sender: self)
                    }
                }else{
                    print("Request Gagal")
                }
        }
    }
    
    @IBAction func masuk(_ sender: UIButton) {
        print("login???")
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
