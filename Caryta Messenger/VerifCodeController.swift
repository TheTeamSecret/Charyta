//
//  VerifCodeController.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/22/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseAuth
import Toaster

class VerifCodeController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var sectionOne: UITextField!
    @IBOutlet weak var sectionTwo: UITextField!
    @IBOutlet weak var sectionThree: UITextField!
    @IBOutlet weak var sectionFour: UITextField!
    @IBOutlet weak var sectionFive: UITextField!
    @IBOutlet weak var sectionSix: UITextField!
    
    var phoneNumber = String()
    var verifID = String()
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // [START remove_auth_listener]
        Auth.auth().removeStateDidChangeListener(handle!)
        // [END remove_auth_listener]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(phoneNumber)
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        PhoneAuthProvider.provider().verifyPhoneNumber("+6289638153240") { verificationID, error in
            
            if error != nil {
                print("Verification code not sent \(error!)")
            } else {
                print ("Successful. \(String(describing: verificationID!))")
                
                self.verifID = String(describing: verificationID!)
                
            }
            
        }
        
        sectionOne.delegate = self
        sectionTwo.delegate = self
        sectionThree.delegate = self
        sectionFour.delegate = self
        sectionFive.delegate = self
        sectionSix.delegate = self
        
        sectionOne.layer.borderWidth = 1.5
        sectionOne.layer.borderColor = UIColor.lightGray.cgColor
        sectionOne.layer.cornerRadius = 5.0
        
        sectionTwo.layer.borderWidth = 1.5
        sectionTwo.layer.borderColor = UIColor.lightGray.cgColor
        sectionTwo.layer.cornerRadius = 5.0
        
        sectionThree.layer.borderWidth = 1.5
        sectionThree.layer.borderColor = UIColor.lightGray.cgColor
        sectionThree.layer.cornerRadius = 5.0
        
        sectionFour.layer.borderWidth = 1.5
        sectionFour.layer.borderColor = UIColor.lightGray.cgColor
        sectionFour.layer.cornerRadius = 5.0
        
        sectionFive.layer.borderWidth = 1.5
        sectionFive.layer.borderColor = UIColor.lightGray.cgColor
        sectionFive.layer.cornerRadius = 5.0
        
        sectionSix.layer.borderWidth = 1.5
        sectionSix.layer.borderColor = UIColor.lightGray.cgColor
        sectionSix.layer.cornerRadius = 5.0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 1 // Bool
        
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
                
                loading.startAnimating()
                
                checkCode()
                
            }else if (sectionSix.text?.characters.count)! == 0 {
                
                sectionFive.becomeFirstResponder()
                
            }
        }
        
    }
    
    func checkCode() {
        
        self.performSegue(withIdentifier: "segue_masuk", sender: self)
        
        let verifCode = "\(sectionOne.text!)\(sectionTwo.text!)\(sectionThree.text!)\(sectionFour.text!)\(sectionFive.text!)\(sectionSix.text!)"
        
        print(verifID)
        print(verifCode)
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verifID, verificationCode: verifCode)
        
        Auth.auth().signIn(with: credential) { (user, error) in
        
            if let error = error {
            
                print(error)
                
                self.loading.stopAnimating()
                
                return
            
            }else{
                
                print(user!)
            
                self.performSegue(withIdentifier: "segue_masuk", sender: self)
            
            }
        
        }
    
    }
    
    @IBAction func resendVerifCode(_ sender: UIButton) {
        
        print(phoneNumber)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber) { verificationID, error in
            
            if error != nil {
                print("Verification code not sent \(error!)")
            } else {
                print ("Successful. \(String(describing: verificationID!))")
                
                self.verifID = String(describing: verificationID!)
                
            }
            
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue_masuk" {
        
            let next = segue.destination as! MasukController
            
            next.phoneNumber = self.phoneNumber
        
        }
        
    }

}
