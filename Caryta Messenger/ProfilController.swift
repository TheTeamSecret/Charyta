//
//  ProfilController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/15/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import RealmSwift

class ProfilController: UIViewController {

    @IBOutlet weak var initialLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarStyle(.lightContent)
        
        initialLbl.layer.cornerRadius = 35
        initialLbl.clipsToBounds = true
        
        let getUser = try! Realm().objects(user.self).first!
        
        self.nameLbl.text = getUser.first_name
        
        if getUser.status == "" {
        
        
        }else{
            
            self.statusLbl.text = getUser.status
        
        }
        
        if getUser.email == "" {
            
            
        }else{
            
            self.emailLbl.text = getUser.email
            
        }
        
        let initIndex = self.nameLbl.text!.index(self.nameLbl.text!.startIndex, offsetBy: 1)
        let initial = self.nameLbl.text!.substring(to: initIndex).uppercased()
        
        self.initialLbl.text = initial
        
        self.initialLbl.backgroundColor = UIColor.randomFlat

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gantiNama(_ sender: UIButton) {
        
        let myParent = self.tabBarController as! MenuBarController
        
        myParent.showEditName(value: self.nameLbl.text!)
        
    }
    
    @IBAction func gantiStatus(_ sender: UIButton) {
        
        let myParent = self.tabBarController as! MenuBarController
        
        myParent.showEditStatus(value: self.nameLbl.text!)
        
    }

    @IBAction func gantiEmail(_ sender: UIButton) {
        
        let myParent = self.tabBarController as! MenuBarController
        
        myParent.showEditEmail(value: self.nameLbl.text!)
        
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
