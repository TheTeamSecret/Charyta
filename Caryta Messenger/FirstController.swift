//
//  FirstController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 8/10/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import Toaster

class FirstController: UIViewController, CLLocationManagerDelegate {
    
    var name = [String]()
    var dial = [String]()
    let locManager = CLLocationManager()

    @IBOutlet weak var dialCountryView: UIView!
    @IBOutlet weak var numberView: UIView!
    
    @IBOutlet weak var dialNameLbl: UILabel!
    @IBOutlet weak var dialCodeLbl: UILabel!
    @IBOutlet weak var numberTF: UITextField!
    
    @IBOutlet weak var loginCarytaBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var pinId = String()
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
    @IBOutlet weak var constDialCode: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FirstController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FirstController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        getKodeNegara()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dialCountryView.addBorder(side: .bottom, thickness: 1.0, color: .white)
        numberView.layer.cornerRadius = 5.0
        numberView.clipsToBounds = true
        loginCarytaBtn.layer.borderColor = UIColor.white.cgColor
        loginCarytaBtn.layer.borderWidth = 1.0
        loginCarytaBtn.layer.cornerRadius = 5.0
        loginCarytaBtn.clipsToBounds = true
        nextBtn.layer.cornerRadius = 5.0
        nextBtn.clipsToBounds = true
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
                            self.dialNameLbl.text = data["name"].stringValue
                            self.dialCodeLbl.text = data["dial_code"].stringValue
                            self.setWidth()
                        }
                        self.name.append(data["name"].stringValue)
                        self.dial.append(data["dial_code"].stringValue)
                    }
                    self.locManager.stopUpdatingLocation()
                }
        }
    }
    
    func getToken() {
        Alamofire.request("\(link().domainMain)get-token", method: .get, headers: ["Authorization": "Basic QGlvc0Nhcnl0YTpjYXJ5dGFJb3NEZXZlbG9wbWVudA=="])
            .responseJSON{response in
                if let jason = response.result.value {
                    self.getOtp(token: JSON(jason)["token"].stringValue)
                }
        }
    }
    
    func getOtp(token: String) {
        Alamofire.request("\(link().domain)otp", method: .post, parameters: ["to": "\(self.dialCodeLbl.text!)\(self.numberTF.text!)"], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json", "Token": token])
            .responseJSON{response in
                if let jason = response.result.value {
                    if JSON(jason)["status"].intValue == 0 {
                        Toast.init(text: JSON(jason)["message"].stringValue).show()
                        if JSON(jason)["message"].stringValue == "Nomor telepon telah terdaftar" {
                            self.performSegue(withIdentifier: "segue_login", sender: self)
                        }
                    }else{
                        self.pinId = JSON(jason)["data"]["pinId"].stringValue
                        self.params["phoneNumber"] = "\(self.dialCodeLbl.text!)\(self.numberTF.text!)"
                        self.performSegue(withIdentifier: "segue_kode_verif", sender: self)
                    }
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setWidth() {
        let newWidth = self.estimatewidthForView(text: self.dialCodeLbl.text!).width
        UIView.animate(withDuration: 0.1, animations: {
            self.constDialCode.constant = newWidth + 8
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func checkNumber(_ sender: UIButton) {
        self.cekNomor()
    }
    
    func cekNomor(){
        let url = "\(link().subDomain)auth/register-cek-nomor"
        let head = [
            "Content-Type" : "application/json"
        ]
        let params = [
            "phoneNumber" : "\(self.dialCodeLbl.text!)\(self.numberTF.text!)"
        ]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: head)
            .responseJSON{response in
                if let jason = response.result.value {
                    let data = JSON(jason)
                    if data["status"].intValue == 0 {
                        print(data["message"].stringValue)
                    }else{
                        print(data["message"].stringValue)
                        self.performSegue(withIdentifier: "showRegister", sender: self)
                    }
                }
        }
    }
    
    @IBAction func chooseCountry(_ sender: UIButton) {
        let Popover = UIStoryboard(name: "NewMain", bundle: nil).instantiateViewController(withIdentifier: "PopUpListDial") as! PopUpListDialController
        Popover.name = self.name
        Popover.dial = self.dial
        self.addChildViewController(Popover)
        Popover.view.frame = self.view.frame
        self.view.addSubview(Popover.view)
        Popover.didMove(toParentViewController: self)
        
    }
    
    private func estimatewidthForView(text: String) -> CGRect {
        let size = CGSize(width: 1000, height: 30)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_kode_verif" {
            let next = segue.destination as! KodeVerifController
            next.params = self.params
            next.pinId = self.pinId
        }
        if segue.identifier == "segue_login" {
            let next = segue.destination as! LoginController
            next.number = self.params["phoneNumber"]!
        }
        if segue.identifier == "showRegister" {
            let next = segue.destination as! DataDiriController
            next.noTelpon = "\(self.dialCodeLbl.text!)\(self.numberTF.text!)"
        }
    }


}
