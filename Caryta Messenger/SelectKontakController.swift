//
//  AddGroupController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/5/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import MapleBacon

class SelectKontakController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var listKontakTV: UITableView!
    
    let getKontak = try! Realm().objects(kontak.self).sorted(byKeyPath: "nama")
    
    var selectedUser = [String]()
    
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func next(_ sender: UIBarButtonItem) {
        
        self.performSegue(withIdentifier: "finish", sender: self)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getKontak.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = listKontakTV.dequeueReusableCell(withIdentifier: "grup", for: indexPath) as! SelectKontakCell
        
        cell.imgProfil.layer.borderWidth = 1.0
        cell.imgProfil.layer.borderColor = UIColor.init(hexString: "CCCCCC")?.cgColor
        cell.imgProfil.layer.cornerRadius = 7.5
        
        cell.imgProfil.setImage(withUrl: URL.init(string: "\(link().gambar)\(getKontak[indexPath.row].gambar)")!, placeholder: UIImage.init(named: "Avatar"), crossFadePlaceholder: true, cacheScaled: false, completion: nil)
        cell.nameLbl.text = getKontak[indexPath.row].nama
        
        cell.selectBtn.layer.borderWidth = 1.0
        cell.selectBtn.layer.borderColor = UIColor.lightGray.cgColor
        cell.selectBtn.layer.cornerRadius = 10.0
        
        return cell
        
    }
    
    @IBAction func selectDeselect(_ sender: UIButton) {
        
        let button = sender
        let bView = button.superview!
        let mainView = bView.superview!
        let cell = mainView.superview as! SelectKontakCell
        
        let indexPath = listKontakTV.indexPath(for: cell)!
        
        if sender.backgroundColor == UIColor.clear {
        
            self.selectedUser.append(getKontak[indexPath.row].user_id)
            sender.backgroundColor = UIColor.init(hexString: "018FD7")
            
            print(self.selectedUser)
            
            if self.selectedUser.count > 0 {
            
                self.nextBtn.isEnabled = true
            
            }else if self.selectedUser.count == 0 {
                
                self.nextBtn.isEnabled = false
                
            }
        
        }else if sender.backgroundColor == UIColor.init(hexString: "018FD7") {
            
            let i = self.selectedUser.index(of: getKontak[indexPath.row].user_id)!
            self.selectedUser.remove(at: i)
            sender.backgroundColor = UIColor.clear
            
            print(self.selectedUser)
            
            if self.selectedUser.count > 0 {
                
                self.nextBtn.isEnabled = true
                
            }else if self.selectedUser.count == 0 {
                
                self.nextBtn.isEnabled = false
                
            }
            
        }
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "finish" {
        
            let next = segue.destination as! AddGroupController
            
            next.idArray.append(contentsOf: self.selectedUser)
        
        }
        
    }

}
