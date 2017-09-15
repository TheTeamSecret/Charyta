//
//  LoginController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 8/10/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import Firebase

class LoginController: UIViewController {

    @IBOutlet weak var imgProfil: UIImageView!
    @IBOutlet weak var passwordTF: UITextField!
    
    var number = String()
    
    func keyboardWillShow(_ notification : NSNotification) {
        
        let keyBoardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        self.bottom.constant = keyBoardSize.height
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        
    }
    
    func keyboardWillHide(_ notification : Notification) {
        
        self.bottom.constant = 0.0
        
        self.view.layoutIfNeeded()
    }
    
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DataDiriController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DataDiriController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.imgProfil.layer.cornerRadius = 80.0
        self.imgProfil.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        let params = [
            "username" : number,
            "password" : self.passwordTF.text!
        ]
        
        Alamofire.request("\(link().domain)login", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    if JSON(jason)["status"].stringValue == "1" {
                        
                        print(JSON(jason).description)
                        
                        let token = InstanceID.instanceID().token()!
                        
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
