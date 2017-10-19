//
//  KodeVerifController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 8/10/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster

class KodeVerifController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var sectionOne: UITextField!
    @IBOutlet weak var sectionTwo: UITextField!
    @IBOutlet weak var sectionThree: UITextField!
    @IBOutlet weak var sectionFour: UITextField!
    @IBOutlet weak var sectionFive: UITextField!
    @IBOutlet weak var sectionSix: UITextField!
    @IBOutlet weak var btnKirim: UIButton!
    
    var noTelpon = ""
    
    func keyboardWillShow(_ notification : NSNotification) {
        let keyBoardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        self.bottom.constant = keyBoardSize.height + 16
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(_ notification : Notification) {
        self.bottom.constant = 24.0
        self.view.layoutIfNeeded()
    }
    
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(KodeVerifController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KodeVerifController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.containerView.layer.cornerRadius = 5.0
        self.containerView.clipsToBounds = true
        self.btnKirim.layer.cornerRadius = 5.0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeSection(_ sender: UITextField) {
        if sender == sectionOne {
            if (sectionOne.text?.characters.count)! > 0 {
                sectionTwo.becomeFirstResponder()
            }
        }else if sender == sectionTwo {
            if (sectionTwo.text?.characters.count)! > 0 {
                sectionThree.becomeFirstResponder()
            }else if (sectionTwo.text?.characters.count)! == 0 {
                sectionOne.becomeFirstResponder()
            }
        }else if sender == sectionThree {
            if (sectionThree.text?.characters.count)! > 0 {
                sectionFour.becomeFirstResponder()
            }else if (sectionThree.text?.characters.count)! == 0 {
                sectionTwo.becomeFirstResponder()
            }
        }else if sender == sectionFour {
            if (sectionFour.text?.characters.count)! > 0 {
                sectionFive.becomeFirstResponder()
            }else if (sectionFour.text?.characters.count)! == 0 {
                sectionThree.becomeFirstResponder()
            }
        }else if sender == sectionFive {
            if (sectionFive.text?.characters.count)! > 0 {
                sectionSix.becomeFirstResponder()
            }else if (sectionFive.text?.characters.count)! == 0 {
                sectionFour.becomeFirstResponder()
            }
        }else if sender == sectionSix{
            if (sectionSix.text?.characters.count)! > 0 {
                self.view.endEditing(true)
            }else if (sectionSix.text?.characters.count)! == 0 {
                sectionFive.becomeFirstResponder()
            }
        }
    }
    
    @IBAction func btnKirimUlangOtp(_ sender: UIButton) {
        
    }
    
    @IBAction func nextStep(_ sender: UIButton) {
        //self.verifyCode()
        //Testing
        self.performSegue(withIdentifier: "showDataDiri", sender: self)
    }
    
    func verifyCode() {
        let code = "\(self.sectionOne.text!)\(self.sectionTwo.text!)\(self.sectionThree.text!)\(self.sectionFour.text!)\(self.sectionFive.text!)\(self.sectionSix.text!)"
        Alamofire.request("\(link().domainMain)2fa/verify-message", method: .post, parameters: ["pinId": self.noTelpon, "code": code], encoding: JSONEncoding.default)
            .responseJSON{response in
                if let jason = response.result.value {
                    if JSON(jason)["status"].intValue == 0 {
                        Toast.init(text: "Verifikasi gagal!!! Pastikan kode yang anda masukkan benar").show()
                    }
                    if JSON(jason)["status"].intValue == 1 {
                        self.performSegue(withIdentifier: "segue_data_diri", sender: self)
                    }
                }
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_data_diri" {
            let conn = segue.destination as! DataDiriController
            conn.noTelpon = self.noTelpon
        }
    }

    @IBAction func btnKembaliTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
