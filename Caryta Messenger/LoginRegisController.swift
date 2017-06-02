//
//  LoginRegisController.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/22/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import Firebase
import FirebaseAuth

class LoginRegisController: UIViewController, CLLocationManagerDelegate {
    
    var name = [String]()
    var dial = [String]()
    
    let locManager = CLLocationManager()
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryDial: UILabel!
    
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    
    @IBOutlet weak var numberTxt: UITextField!
    
    var go: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        
        getKodeNegara()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getKodeNegara() {
        
        Alamofire.request("\(link().domain)kode-telepon")
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    print(JSON(jason).description)
                    
                    let local = Locale.current
                    print(local.regionCode!)
                    
                    for data in JSON(jason).array! {
                        
                        if data["code"].stringValue == local.regionCode! {
                        
                            self.countryName.text = data["name"].stringValue
                            self.countryDial.text = data["dial_code"].stringValue
                        
                        }
                    
                        self.name.append(data["name"].stringValue)
                        self.dial.append(data["dial_code"].stringValue)
                        
                    }
                    
                    print(self.name)
                    print(self.dial)
                    
                    self.locManager.stopUpdatingLocation()
                    
                }
                
        }
        
    }
    
    @IBAction func check(_ sender: UITextField) {
        
        if sender.text!.characters.count > 0 {
        
            nextBtn.isEnabled = true
        
        }else if sender.text!.characters.count == 0 {
            
            nextBtn.isEnabled = false
            
        }
        
    }
    
    @IBAction func changeCountry(_ sender: UIButton) {
        
        let Popover = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kode") as! ListDialController
        
        self.nextBtn.title = ""
        
        Popover.name.append(contentsOf: self.name)
        Popover.dial.append(contentsOf: self.dial)
        
        self.addChildViewController(Popover)
        Popover.view.frame = self.view.frame
        self.view.addSubview(Popover.view)
        Popover.didMove(toParentViewController: self)
        
    }
    
    @IBAction func goToVerifikasi(_ sender: UIBarButtonItem) {
        
        self.cekNomor()
        
    }
    
    func cekNomor(){
        
        Alamofire.request("\(link().domain)cek-nomor", method: .post, parameters: ["phoneNumber": "0\(self.numberTxt.text!)"], encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    print(JSON(jason).description)
                    
                    if JSON(jason)["status"].stringValue == "0" {
                        
                        self.performSegue(withIdentifier: "segue_password", sender: self)
                        
                    }else{
                        
                        Alamofire.request("\(link().domain)cek-nomor", method: .post, parameters: ["phoneNumber": "62\(self.numberTxt.text!)"], encoding: JSONEncoding.default)
                            .responseJSON{response in
                                
                                if let jason = response.result.value {
                                    
                                    print(JSON(jason).description)
                                    
                                    if JSON(jason)["status"].stringValue == "0" {
                                        
                                        self.performSegue(withIdentifier: "segue_password", sender: self)
                                        
                                    }else{
                                        
                                        Alamofire.request("\(link().domain)cek-nomor", method: .post, parameters: ["phoneNumber": "+62\(self.numberTxt.text!)"], encoding: JSONEncoding.default)
                                            .responseJSON{response in
                                                
                                                if let jason = response.result.value {
                                                    
                                                    print(JSON(jason).description)
                                                    
                                                    if JSON(jason)["status"].stringValue == "0" {
                                                        
                                                        self.performSegue(withIdentifier: "segue_password", sender: self)
                                                        
                                                    }else{
                                                        
                                                        Alamofire.request("\(link().domain)cek-nomor", method: .post, parameters: ["phoneNumber": self.numberTxt.text!], encoding: JSONEncoding.default)
                                                            .responseJSON{response in
                                                                
                                                                if let jason = response.result.value {
                                                                    
                                                                    print(JSON(jason).description)
                                                                    
                                                                    if JSON(jason)["status"].stringValue == "0" {
                                                                        
                                                                        self.performSegue(withIdentifier: "segue_password", sender: self)
                                                                        
                                                                    }else{
                                                                        
                                                                        self.performSegue(withIdentifier: "segue_verifikasi", sender: self)
                                                                        
                                                                    }
                                                                    
                                                                }
                                                                
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                                
                                        }
                                        
                                    }
                                    
                                }
                                
                        }
                    
                    }
                    
                }
                
        }
    
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue_verifikasi" {
        
            let next = segue.destination as! VerifCodeController
            next.phoneNumber = "\(countryDial.text!)\(numberTxt.text!)"
         
        }else if segue.identifier == "segue_password" {
        
            let next = segue.destination as! LoginController
            next.username = "\(countryDial.text!)\(numberTxt.text!)"
        
        }
        
    }

}
