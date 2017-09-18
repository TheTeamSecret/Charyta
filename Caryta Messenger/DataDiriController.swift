//
//  DataDiriController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 8/10/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import RealmSwift

class DataDiriController: UIViewController {

    @IBOutlet weak var imgProfil: UIImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    
    var params = [String:String]()
    
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
    
    @IBAction func selesai(_ sender: UIButton) {
        
        let token = InstanceID.instanceID().token()!
        
        params["firstName"] = self.firstNameTF.text!
        params["lastName"] = self.lastNameTF.text!
        params["sex"] = self.genderTF.text!
        params["password"] = self.passwordTF.text!
        params["registrasiId"] = token
        
        Alamofire.request("\(link().domainMain)messenger/registrasi", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    print(JSON(jason).description)
                    
                    let model = user()
                    
                    model.user_id       = JSON(jason)["data"]["userId"].stringValue
                    model.first_name    = self.firstNameTF.text!
                    model.last_name     = self.lastNameTF.text!
                    model.sex           = self.genderTF.text!
                    model.no_hp         = self.params["phoneNumber"]!
                    model.email         = ""
                    model.avatar        = ""
                    
                    DBHelper.insert(obj: model)
                    
                    self.performSegue(withIdentifier: "segue_main", sender: self)
                    
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
