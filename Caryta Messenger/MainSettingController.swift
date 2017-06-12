//
//  MainSettingController.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/16/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import RealmSwift

class MainSettingController: UIViewController {

    @IBOutlet weak var imgProfil: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    let getUser = try! Realm().objects(user.self).first!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarStyle(.lightContent)
        
        nameLbl.text = getUser.first_name
        
        imgProfil.layer.cornerRadius = 25
        imgProfil.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToEditProfil(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "segue_edit_profil", sender: self)
        
    }

    @IBAction func goToSetNotif(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "segue_set_notif", sender: self)
        
    }
    
    @IBAction func goToSetAkun(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "segue_set_akun", sender: self)
        
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
