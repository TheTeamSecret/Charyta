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

    @IBOutlet weak var viewUsername: UIView!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var btnMasuk: UIButton!
    @IBOutlet weak var btnDaftar: UIButton!
    
    var isFill: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDesign()
        
        //self.topConst.constant = (self.view.frame.size.height - 50 - 167) / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setDesign(){
        self.viewUsername.layer.cornerRadius = 5
        self.viewPassword.layer.cornerRadius = 5
        self.btnMasuk.layer.cornerRadius = 5
        self.btnDaftar.layer.cornerRadius = 5
    }
    
    @IBAction func masuk(_ sender: UIButton) {
        self.login()
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
}
