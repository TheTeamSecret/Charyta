//
//  ListKontakController.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/18/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import RealmSwift
import ContactsUI
import Alamofire
import SwiftyJSON

class ListKontakController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CNContactViewControllerDelegate {
    
    let store = CNContactStore()
    var name = [String]()
    var number = [String]()
    var getContactNumber = ""
    var getContactName = ""
    
    var sentChatID = ""
    var sentName = ""
    
    @IBOutlet weak var loading: UIActivityIndicatorView!

    @IBOutlet weak var kontakTV: UITableView!
    @IBOutlet weak var kontakTVHeight: NSLayoutConstraint!
    @IBOutlet weak var grupImg: UIImageView!
    @IBOutlet weak var kontakImg: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var refreshBtn: UIBarButtonItem!
    
    var alfabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findContacts()
        
        self.setStatusBarStyle(.lightContent)
        
        grupImg.layer.borderWidth = 1.0
        grupImg.layer.borderColor = UIColor.init(hexString: "CCCCCC")?.cgColor
        grupImg.layer.cornerRadius = 7.5
        
        kontakImg.layer.borderWidth = 1.0
        kontakImg.layer.borderColor = UIColor.init(hexString: "CCCCCC")?.cgColor
        kontakImg.layer.cornerRadius = 7.5
        
        kontakTV.reloadData()
        kontakTVHeight.constant = kontakTV.contentSize.height

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let getKontak = try! Realm().objects(kontak.self).sorted(byKeyPath: "nama")
        
//        var row: Int = 1
//        
//        let getAllKontak = try! Realm().objects(kontak.self)
//        
//        if getAllKontak.count == 0 {
//        
//            row = 1
//        
//        }else{
//        
//            for sect in alfabet {
//            
//                let i = alfabet.index(of: sect)!
//                
//                if section == i {
//                    
//                    let getKontak = try! Realm().objects(kontak.self).filter("nama BEGINSWITH '\(sect)'")
//                    
//                    row = getKontak.count + 1
//                    
//                }
//            
//            }
//            
//        }
        
        return getKontak.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let getKontak = try! Realm().objects(kontak.self).sorted(byKeyPath: "nama")
        
        let cell = kontakTV.dequeueReusableCell(withIdentifier: "kontak", for: indexPath) as! ListKontakCell
        
        cell.avaImg.layer.borderWidth = 1.0
        cell.avaImg.layer.borderColor = UIColor.init(hexString: "CCCCCC")?.cgColor
        cell.avaImg.layer.cornerRadius = 7.5
        
        cell.avaImg.setImage(withUrl: URL.init(string: "\(link().gambar)\(getKontak[indexPath.row].gambar)")!, placeholder: UIImage.init(named: "Avatar"), crossFadePlaceholder: true, cacheScaled: false, completion: nil)
        cell.nameLbl.text = getKontak[indexPath.row].nama
        cell.statusLbl.text = getKontak[indexPath.row].status
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let getKontak = try! Realm().objects(kontak.self).sorted(byKeyPath: "nama", ascending: true)
        
        sentName = getKontak[indexPath.row].nama
        
        let getChat = try! Realm().objects(chat.self).filter("name = '\(sentName)'")
        
        if getChat.count > 0 {
            
            print(getChat.first!.chat_id)
            
            sentChatID = getChat.first!.chat_id
            
            self.performSegue(withIdentifier: "segue_detail_chat", sender: self)
            
        }else if getChat.count == 0 {
            
            sentChatID = ""
            
            self.performSegue(withIdentifier: "segue_detail_chat", sender: self)
            
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(false, animated: true)
        self.view.endEditing(true)
        
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
        
        Alamofire.request("\(link().domain)check-contact", method: .post, parameters: ["phoneNumber": phoneNumber], encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    if JSON(jason)["status"].stringValue == "1" {
                        
                        print(JSON(jason).description)
                        
                        let model = kontak()
                        
                        let data = JSON(jason)["data"]
                        
                        let i = self.number.index(of: original)!
                        
                        model.user_id       =   data["user_id"].stringValue
                        model.nama          =   self.name[i]
                        model.gambar        =   data["gambar_small"].stringValue
                        model.status        =   data["status"].stringValue
                        model.registrasi_id =   data["registrasi_id"].stringValue
                        
                        DBHelper.update(obj: model)
                        
                        self.kontakTV.reloadData()
                        
                        if original == self.number.last! {
                            
                            self.loading.stopAnimating()
                            self.loading.isHidden = true
                            self.refreshBtn.isEnabled = true
                            
                        }
                        
                    }else{
                        
                        self.checkKontak0(phoneNumber: phoneNumber, original: original)
                        
                    }
                    
                }
                
        }
        
    }
    
    func checkKontak0(phoneNumber: String, original: String){
        
        Alamofire.request("\(link().domain)check-contact", method: .post, parameters: ["phoneNumber": "0\(phoneNumber)"], encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    if JSON(jason)["status"].stringValue == "1" {
                        
                        print(JSON(jason).description)
                        
                        let model = kontak()
                        
                        let data = JSON(jason)["data"]
                        
                        let i = self.number.index(of: original)!
                        
                        model.user_id       =   data["user_id"].stringValue
                        model.nama          =   self.name[i]
                        model.gambar        =   data["gambar_small"].stringValue
                        model.status        =   data["status"].stringValue
                        model.registrasi_id =   data["registrasi_id"].stringValue
                        
                        DBHelper.update(obj: model)
                        
                        self.kontakTV.reloadData()
                        
                        if original == self.number.last! {
                            
                            self.loading.stopAnimating()
                            self.loading.isHidden = true
                            self.refreshBtn.isEnabled = true
                            
                        }
                        
                    }else{
                        
                        self.checkKontak62(phoneNumber: phoneNumber, original: original)
                        
                    }
                    
                }
                
        }
        
    }
    
    func checkKontak62(phoneNumber: String, original: String){
        
        Alamofire.request("\(link().domain)check-contact", method: .post, parameters: ["phoneNumber": "62\(phoneNumber)"], encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    if JSON(jason)["status"].stringValue == "1" {
                        
                        print(JSON(jason).description)
                        
                        let model = kontak()
                        
                        let data = JSON(jason)["data"]
                        
                        let i = self.number.index(of: original)!
                        
                        model.user_id       =   data["user_id"].stringValue
                        model.nama          =   self.name[i]
                        model.gambar        =   data["gambar_small"].stringValue
                        model.status        =   data["status"].stringValue
                        model.registrasi_id =   data["registrasi_id"].stringValue
                        
                        DBHelper.update(obj: model)
                        
                        self.kontakTV.reloadData()
                        
                        if original == self.number.last! {
                            
                            self.loading.stopAnimating()
                            self.loading.isHidden = true
                            self.refreshBtn.isEnabled = true
                            
                        }
                        
                    }else{
                        
                        self.checkKontakPlus62(phoneNumber: phoneNumber, original: original)
                        
                    }
                    
                }
                
        }
        
    }
    
    func checkKontakPlus62(phoneNumber: String, original: String){
        
        Alamofire.request("\(link().domain)check-contact", method: .post, parameters: ["phoneNumber": "+62\(phoneNumber)"], encoding: JSONEncoding.default)
            .responseJSON{response in
                
                if let jason = response.result.value {
                    
                    if JSON(jason)["status"].stringValue == "1" {
                        
                        print(JSON(jason).description)
                        
                        let model = kontak()
                        
                        let data = JSON(jason)["data"]
                        
                        let i = self.number.index(of: original)!
                        
                        model.user_id       =   data["user_id"].stringValue
                        model.nama          =   self.name[i]
                        model.gambar        =   data["gambar_small"].stringValue
                        model.status        =   data["status"].stringValue
                        model.registrasi_id =   data["registrasi_id"].stringValue
                        
                        DBHelper.update(obj: model)
                        
                        self.kontakTV.reloadData()
                        
                    }
                    
                    if original == self.number.last! {
                        
                        self.loading.stopAnimating()
                        self.loading.isHidden = true
                        self.refreshBtn.isEnabled = true
                        
                    }
                    
                }
                
        }
        
    }
    
    @IBAction func refreshKontak(_ sender: UIBarButtonItem) {
        
        loading.startAnimating()
        loading.isHidden = false
        
        refreshBtn.isEnabled = false
        
        refresh()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue_detail_chat" {
        
            let next = segue.destination as! DetailChatController
            
            next.chatID = self.sentChatID
            next.nama = self.sentName
        
        }
        
    }

}
