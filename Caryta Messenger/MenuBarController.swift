//
//  MenuBarController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/13/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import ContactsUI
import Alamofire
import SwiftyJSON
import RealmSwift
import Firebase

class MenuBarController: UITabBarController, CNContactViewControllerDelegate {
    
    let store = CNContactStore()
    var name = [String]()
    var number = [String]()
    var getContactNumber = ""
    var getContactName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setStatusBarStyle(.lightContent)
        let getKontak = try! Realm().objects(kontak.self)
        if getKontak.count > 0 {
            
            for itemKontak in getKontak {
                
                if itemKontak.registrasi_id == "" {
                    
                    DBHelper.delete(obj: itemKontak)
                    
                }
                
            }
            
        }
        
        findContacts()
        
        refresh()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showComment() {
        
        let Popover = UIStoryboard(name: "NewMain", bundle: nil).instantiateViewController(withIdentifier: "komen") as! PopUpKomentarController
        
        self.addChildViewController(Popover)
        Popover.view.frame = self.view.frame
        self.view.addSubview(Popover.view)
        Popover.didMove(toParentViewController: self)
    
    }
    
    func showEditName(value: String) {
        
        let Popover = UIStoryboard(name: "NewMain", bundle: nil).instantiateViewController(withIdentifier: "edit") as! PopUpUbahDataController
        
        Popover.oldItem = value
        Popover.from = "nama"
        
        self.addChildViewController(Popover)
        Popover.view.frame = self.view.frame
        self.view.addSubview(Popover.view)
        Popover.didMove(toParentViewController: self)
    
    }
    
    func showEditStatus(value: String) {
        
        let Popover = UIStoryboard(name: "NewMain", bundle: nil).instantiateViewController(withIdentifier: "edit") as! PopUpUbahDataController
        
        Popover.oldItem = value
        Popover.from = "status"
        
        self.addChildViewController(Popover)
        Popover.view.frame = self.view.frame
        self.view.addSubview(Popover.view)
        Popover.didMove(toParentViewController: self)
        
    }
    
    func showEditEmail(value: String) {
        
        let Popover = UIStoryboard(name: "NewMain", bundle: nil).instantiateViewController(withIdentifier: "edit") as! PopUpUbahDataController
        
        Popover.oldItem = value
        Popover.from = "email"
        
        self.addChildViewController(Popover)
        Popover.view.frame = self.view.frame
        self.view.addSubview(Popover.view)
        Popover.didMove(toParentViewController: self)
        
    }
    
    func findContacts() -> [CNContact] {
        let keysToFetch = [CNContactGivenNameKey, CNContactMiddleNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
        let contacts = [CNContact]()
        self.name.removeAll()
        self.number.removeAll()
        do{
            try! store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                if contact.phoneNumbers.count > 0 {
                    let get = (contact.phoneNumbers[0].value as CNPhoneNumber).value(forKey: "digits") as! String
                    
                    let countNumber = get.characters.count
                    if countNumber > 9 {
                        
                        self.getContactNumber = get
                        var contName = ""
                        if contact.givenName != "" {
                            contName += contact.givenName
                        }
                        if contact.middleName != "" {
                            contName += " " + contact.middleName
                        }
                        if contact.familyName != "" {
                            contName += " " + contact.familyName
                        }
                        self.getContactName = contName
                        self.name.append(self.getContactName)
                        self.number.append(get)
                    }
                }
            }
            )
            return contacts
        }
    }
    
    func refresh() {
        
        for numb in number {
            
            let indexStr = numb.index(numb.startIndex, offsetBy: 1)
            let prefix = numb.substring(to: indexStr)
            
            if prefix == "+" {
                
                let indexStrNew = numb.index(numb.startIndex, offsetBy: 3)
                let newNumber = numb.substring(from: indexStrNew)
                checkKontak(phoneNumber: newNumber, original: numb)
                
            }else if prefix == "0" {
                
                let indexStrNew = numb.index(numb.startIndex, offsetBy: 1)
                let newNumber = numb.substring(from: indexStrNew)
                checkKontak(phoneNumber: newNumber, original: numb)
                
            }
            
        }
        
    }
    
    func checkKontak(phoneNumber: String, original: String){
        
        let getUser = try! Realm().objects(user.self).first!
        
        Alamofire.request("\(link().domain)check-contact", method: .post, parameters: ["phoneNumber": phoneNumber], encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    if JSON(jason)["status"].stringValue == "1" {
                        
                        print(JSON(jason).description)
                        
                        let model = kontak()
                        
                        let data = JSON(jason)["data"]
                        
                        if data["registrasi_id"].stringValue != "" {
                            
                            let i = self.number.index(of: original)!
                            
                            model.user_id       =   data["user_id"].stringValue
                            model.nama          =   self.name[i]
                            model.gambar        =   data["gambar_small"].stringValue
                            model.status        =   data["status"].stringValue
                            model.registrasi_id =   data["registrasi_id"].stringValue
                            model.phone         =   phoneNumber
                            
                            DBHelper.update(obj: model)
                            
                            self.setNick(pemberi: getUser.user_id, pemilik: data["user_id"].stringValue, nick: self.name[i])
                            
                        }else{
                            
                            self.checkKontak0(phoneNumber: phoneNumber, original: original)
                            
                        }
                        
                    }else{
                        
                        self.checkKontak0(phoneNumber: phoneNumber, original: original)
                        
                    }
                    
                }
                
        }
        
    }
    
    func checkKontak0(phoneNumber: String, original: String){
        let getUser = try! Realm().objects(user.self).first!
        Alamofire.request("\(link().domain)check-contact", method: .post, parameters: ["phoneNumber": "0\(phoneNumber)"], encoding: JSONEncoding.default)
            .responseJSON{response in
                if let jason = response.result.value {
                    if JSON(jason)["status"].stringValue == "1" {
                        print(JSON(jason).description)
                        let model = kontak()
                        let data = JSON(jason)["data"]
                        if data["registrasi_id"].stringValue != "" {
                            let i = self.number.index(of: original)!
                            model.user_id       =   data["user_id"].stringValue
                            model.nama          =   self.name[i]
                            model.gambar        =   data["gambar_small"].stringValue
                            model.status        =   data["status"].stringValue
                            model.registrasi_id =   data["registrasi_id"].stringValue
                            model.phone         =   "0\(phoneNumber)"
                            DBHelper.update(obj: model)
                            self.setNick(pemberi: getUser.user_id, pemilik: data["user_id"].stringValue, nick: self.name[i])
                        }else{
                            self.checkKontak62(phoneNumber: phoneNumber, original: original)
                        }
                    }else{
                        self.checkKontak62(phoneNumber: phoneNumber, original: original)
                    }
                }
        }
    }
    
    func checkKontak62(phoneNumber: String, original: String){
        
        let getUser = try! Realm().objects(user.self).first!
        
        Alamofire.request("\(link().domain)check-contact", method: .post, parameters: ["phoneNumber": "62\(phoneNumber)"], encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    if JSON(jason)["status"].stringValue == "1" {
                        
                        print(JSON(jason).description)
                        
                        let model = kontak()
                        
                        let data = JSON(jason)["data"]
                        
                        if data["registrasi_id"].stringValue != "" {
                            
                            let i = self.number.index(of: original)!
                            
                            model.user_id       =   data["user_id"].stringValue
                            model.nama          =   self.name[i]
                            model.gambar        =   data["gambar_small"].stringValue
                            model.status        =   data["status"].stringValue
                            model.registrasi_id =   data["registrasi_id"].stringValue
                            model.phone         =   "62\(phoneNumber)"
                            
                            DBHelper.update(obj: model)
                            
                            self.setNick(pemberi: getUser.user_id, pemilik: data["user_id"].stringValue, nick: self.name[i])
                            
                        }else{
                            
                            self.checkKontakPlus62(phoneNumber: phoneNumber, original: original)
                            
                        }
                        
                    }else{
                        
                        self.checkKontakPlus62(phoneNumber: phoneNumber, original: original)
                        
                    }
                    
                }
                
        }
        
    }
    
    func checkKontakPlus62(phoneNumber: String, original: String){
        
        let getUser = try! Realm().objects(user.self).first!
        
        Alamofire.request("\(link().domain)check-contact", method: .post, parameters: ["phoneNumber": "+62\(phoneNumber)"], encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    if JSON(jason)["status"].stringValue == "1" {
                        
                        print(JSON(jason).description)
                        
                        let model = kontak()
                        
                        let data = JSON(jason)["data"]
                        
                        if data["registrasi_id"].stringValue != "" {
                            
                            let i = self.number.index(of: original)!
                            
                            model.user_id       =   data["user_id"].stringValue
                            model.nama          =   self.name[i]
                            model.gambar        =   data["gambar_small"].stringValue
                            model.status        =   data["status"].stringValue
                            model.registrasi_id =   data["registrasi_id"].stringValue
                            model.phone         =   "+62\(phoneNumber)"
                            
                            DBHelper.update(obj: model)
                            
                            self.setNick(pemberi: getUser.user_id, pemilik: data["user_id"].stringValue, nick: self.name[i])
                            
                        }
                        
                    }
                    
                }
                
        }
        
    }
    
    func setNick(pemberi: String, pemilik: String, nick: String) {
        
        let params = [
            "userPemberi"   : pemberi,
            "userPemilik"   : pemilik,
            "name"          : nick
        ]
        
        Alamofire.request("\(link().domain)nickname", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    print(JSON(jason).description)
                    
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
