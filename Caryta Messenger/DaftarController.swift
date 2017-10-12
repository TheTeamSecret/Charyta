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
//        self.cekNomor()
        self.performSegue(withIdentifier: "showOtp", sender: self)
    }
    
    func cekNomor(){
        let url = "\(link().subDomain)auth/register-cek-nomor"
        let head = [
            "Content-Type" : "application/json"
        ]
        let params = [
            "phoneNumber" : "\(self.txtNoTelpon.text!)"
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
    
    @IBAction func btnKembaliTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
