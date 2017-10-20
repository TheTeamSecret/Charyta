//
//  ListKontakController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/13/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import RealmSwift
import ContactsUI
import Alamofire
import SwiftyJSON
import MapleBacon
import NAExpandableTableController

class ListKontakController: UIViewController, NAExpandableTableViewDataSource, NAExpandableTableViewDelegate , UISearchBarDelegate, CNContactViewControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate var expendableTableController: NAExpandableTableController!
    
    @IBOutlet weak var kontakTV: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var addDeleteBtn: UIBarButtonItem!
    var isEdit: Bool = false
    
    let store = CNContactStore()
    var name = [String]()
    var number = [String]()
    var getContactNumber = ""
    var getContactName = ""
    
    let addContact = CNContactViewController.init(forNewContact: CNContact())
    
    var sentChatID = ""
    var sentName = ""
    
    var from = ""
    
    var groupID = [String]()
    var groupName = [String]()
    var groupImage = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarStyle(.lightContent)
        
        self.expendableTableController = NAExpandableTableController(dataSource: self, delegate: self)
        kontakTV.dataSource = self.expendableTableController
        kontakTV.delegate = self.expendableTableController
        kontakTV.tableFooterView = UIView(frame: CGRect.zero)
        
        self.getListGroup()
        
        self.findContacts()
        let getKontak = try! Realm().objects(kontak.self)
        if getKontak.count > 0 {
            for itemKontak in getKontak {
                if itemKontak.registrasi_id == "" {
                    DBHelper.delete(obj: itemKontak)
                }
            }
        }
        let filterKontak = try! Realm().objects(kontak.self)
        if filterKontak.count == 0 {
            self.refresh()
        }
    }
    
    func getListGroup() {
        let getUser = try! Realm().objects(user.self).first!
        Alamofire.request("\(link().subDomain)user/render-group", method: .get, encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(getUser.token)"])
            .responseJSON{response in
                if let jason = response.result.value {
                    print("group", jason)
                    let msg = JSON(jason)["message"].stringValue
                    print("status", msg)
                    if msg == "" {
                        for data in JSON(jason).array! {
                            self.groupID.append(data["kode_group"].stringValue)
                            self.groupName.append(data["nama_group"].stringValue)
                            self.groupImage.append(data["gambar"].stringValue)
                        }
                        self.kontakTV.reloadData()
                    }
                }else{
                    print("Request getListGroup Gagal")
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInExpandableTableView(_ tableView: UITableView) -> Int {
        return 2
    }
    
    func expandableTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let getKontak = try! Realm().objects(kontak.self).sorted(byKeyPath: "nama")
        var row = 0
        if section == 0 {
            row = self.groupID.count
            if self.groupID.count == 0 {}
        }
        if section == 1 {
            row = getKontak.count
            if getKontak.count == 0 {}
        }
        return row
    }
    
    func expandableTableView(_ tableView: UITableView, titleCellForSection section: Int, expanded: Bool) -> UITableViewCell {
        let cell = kontakTV.dequeueReusableCell(withIdentifier: "header") as! KontakHeaderCell
        let getKontak = try! Realm().objects(kontak.self).sorted(byKeyPath: "nama")
        if section == 0 {
            cell.headerLbl.text = "Grup \(self.groupID.count)"
        }
        if section == 1 {
            cell.headerLbl.text = "Teman \(getKontak.count)"
        }
        return cell
    }
    
    func expandableTableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = kontakTV.dequeueReusableCell(withIdentifier: "kontak", for: indexPath) as! ListKontakCell
        
        cell.initialLbl.layer.cornerRadius = 20
        cell.initialLbl.clipsToBounds = true
        cell.initialLbl.backgroundColor = UIColor.randomFlat
        
        let getKontak = try! Realm().objects(kontak.self).sorted(byKeyPath: "nama")
        
        if indexPath.section == 0 {
            cell.nameLbl.text = self.groupName[indexPath.row]
            cell.phoneLbl.isHidden = true
            cell.msgBtn.isHidden = false//true
            cell.callBtn.isHidden = true
            cell.statusLbl.text = ""
            let initIndex = self.groupName[indexPath.row].index(self.groupName[indexPath.row].startIndex, offsetBy: 1)
            let initial = self.groupName[indexPath.row].substring(to: initIndex).uppercased()
            cell.initialLbl.text = initial
        }
        if indexPath.section == 1 {
            cell.nameLbl.text = getKontak[indexPath.row].nama
            cell.statusLbl.text = "Ada"//getKontak[indexPath.row].status
            let initIndex = getKontak[indexPath.row - 4].nama.index(getKontak[indexPath.row - 4].nama.startIndex, offsetBy: 1)
            let initial = getKontak[indexPath.row - 4].nama.substring(to: initIndex).uppercased()
            cell.initialLbl.text = initial
        }
        if isEdit == true {
            cell.selectBtnWidth.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                cell.selectBtnWidth.constant = 25
                self.view.layoutIfNeeded()
            })
        }else if isEdit == false {
            cell.selectBtnWidth.constant = 25
            UIView.animate(withDuration: 0.3, animations: {
                cell.selectBtnWidth.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        return cell
    }
    
    func expandableTableView(_ tableView: UITableView, heightForTitleCellInSection section: Int) -> CGFloat {
        return 30
    }
    
    func expandableTableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    @IBAction func editAct(_ sender: UIBarButtonItem) {
        if sender.title == "Edit" {
            addDeleteBtn.image = UIImage.init(named: "hapus")
            isEdit = true
            editBtn.title = "Cancel"
            kontakTV.reloadData()
        }else if sender.title == "Cancel" {
            addDeleteBtn.image = UIImage.init(named: "add_kontak")
            isEdit = false
            editBtn.title = "Edit"
            kontakTV.reloadData()
        }
    }
    
    @IBAction func selctDeselect(_ sender: UIButton) {
        if sender.imageView?.image == UIImage.init(named: "select") {
            sender.setImage(UIImage.init(named: "select_blue"), for: .normal)
        }else if sender.imageView?.image == UIImage.init(named: "select_blue") {
            sender.setImage(UIImage.init(named: "select"), for: .normal)
        }
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
        for numb in self.number {
            let indexStr = numb.index(numb.startIndex, offsetBy: 1)
            let prefix = numb.substring(to: indexStr)
            if prefix == "+" {
                let indexStrNew = numb.index(numb.startIndex, offsetBy: 1)
                let newNumber = numb.substring(from: indexStrNew)
                let countKontak = try! Realm().objects(kontak.self)
                if countKontak.count > 0 {
                    let filterKontak = try! Realm().objects(kontak.self).filter("phone = \(newNumber)")
                    if filterKontak.count == 0 {
                        self.checkContact(newNumber, original: numb)
                    }
                }else{
                    self.checkContact(newNumber, original: numb)
                }
            }
            if prefix == "0" {
                let indexStrNew = numb.index(numb.startIndex, offsetBy: 1)
                let newNumber = numb.substring(from: indexStrNew)
                let phoneNumber = "62" + newNumber
                let countKontak = try! Realm().objects(kontak.self)
                if countKontak.count > 0 {
                    let filterKontak = try! Realm().objects(kontak.self).filter("phone = \(newNumber)")
                    if filterKontak.count == 0 {
                        self.checkContact(phoneNumber, original: numb)
                    }
                }else{
                    self.checkContact(phoneNumber, original: numb)
                }
            }
        }
    }
    
    func checkContact(_ phoneNumber: String, original: String){
        let getUser = try! Realm().objects(user.self).first!
        Alamofire.request("\(link().subDomain)user/check-contact/\(phoneNumber)", method: .get, encoding: JSONEncoding.default, headers: ["Authorization" : "Bearer \(getUser.token)"])
            .responseJSON{response in
                if let jason = response.result.value {
                    print("Kontak", jason)
                    let data = JSON(jason)
                    let model = kontak()
                    model.user_id       =   data["user_penerima"].stringValue
                    let i = self.number.index(of: original)!
                    model.nama          =   self.name[i]
                    model.gambar        =   ""//data["gambar_small"].stringValue
                    model.status        =   ""//data["status"].stringValue
                    model.registrasi_id =   ""//data["registrasi_id"].stringValue
                    model.phone         =   data["telepon"].stringValue
                    DBHelper.insert(obj: model)
                    
                    self.kontakTV.reloadData()
                }else{
                    print("Request check contact Gagal")
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
                        if data["registrasi_id"].stringValue != "" {
                            let i = self.number.index(of: original)!
                            model.user_id       =   data["user_id"].stringValue
                            model.nama          =   self.name[i]
                            model.gambar        =   data["gambar_small"].stringValue
                            model.status        =   data["status"].stringValue
                            model.registrasi_id =   data["registrasi_id"].stringValue
                            model.phone         =   phoneNumber
                            DBHelper.update(obj: model)
                            
                            self.kontakTV.reloadData()
                        }
                    }
                }
        }
    }
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addKontak(_ sender: UIBarButtonItem) {
        addContact.delegate = self
        let navController = UINavigationController.init(rootViewController: addContact)
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func btnMsgTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segue_detail_chat", sender: self)
    }
    
    @IBAction func btnCallTapped(_ sender: UIButton) {
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        self.view.endEditing(true)
    }
 
}
