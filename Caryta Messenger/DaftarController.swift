//
//  DaftarController.swift
//  Caryta Messenger
//
//  Created by Ari Maulana on 10/12/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class DaftarController: UIViewController {
    
    @IBOutlet weak var viewTxtNoTelpon: UIView!
    @IBOutlet weak var txtNoTelpon: UITextField!
    @IBOutlet weak var btnLanjut: UIButton!
    
    var noTelpon = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewTxtNoTelpon.layer.cornerRadius = 5
        self.btnLanjut.layer.cornerRadius = 5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnLanjutTapped(_ sender: UIButton) {
        let number = self.txtNoTelpon.text!
        let indexStr = number.index(number.startIndex, offsetBy: 1)
        let prefix = number.substring(to: indexStr)
        if prefix == "0" {
            let indexStrNew = number.index(number.startIndex, offsetBy: 1)
            let removeFirst = number.substring(from: indexStrNew)
            let newNumber = "62" + removeFirst
            self.noTelpon = newNumber
        }
        if prefix == "+" {
            let indexStrNew = number.index(number.startIndex, offsetBy: 1)
            let newNumber = number.substring(from: indexStrNew)
            self.noTelpon = newNumber
        }
//        self.cekNomor()
        
        //Testing
        self.performSegue(withIdentifier: "showOtp", sender: self)
    }
    
    func cekNomor(){
        let url = "\(link().subDomain)auth/register-cek-nomor"
        let head = [
            "Content-Type" : "application/json"
        ]
        let params = [
            "phoneNumber" : self.noTelpon
        ]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: head)
            .responseJSON{response in
                if let jason = response.result.value {
                    let data = JSON(jason)
                    if data["status"].intValue == 0 {
                        let msg = data["message"].stringValue
                        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in }))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        self.performSegue(withIdentifier: "showOtp", sender: self)
                    }
                }else{
                    print("Request Gagal")
                    let alert = UIAlertController(title: "Error", message: "Terjadi kesalahan, selahkan coba beberapa saat lagi", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in }))
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOtp" {
            let conn = segue.destination as! KodeVerifController
            conn.noTelpon = self.noTelpon
        }
    }
    
    @IBAction func btnKembaliTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
