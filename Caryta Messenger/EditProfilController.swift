//
//  EditProfilController.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/17/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import RealmSwift

class EditProfilController: UIViewController {
    
    @IBOutlet weak var namaTF: UITextField!
    @IBOutlet weak var infoTF: UILabel!
    @IBOutlet weak var phoneTF: UILabel!
    
    let getUser = try! Realm().objects(user.self).first!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.namaTF.text = getUser.first_name
        self.phoneTF.text = getUser.no_hp
        
        self.setStatusBarStyle(.lightContent)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToEditPhoto(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "segue_edit_photo", sender: self)
        
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
