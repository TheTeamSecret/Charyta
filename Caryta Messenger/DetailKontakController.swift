//
//  DetailKontakController.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/17/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import RealmSwift
import MapleBacon

class DetailKontakController: UIViewController {

    @IBOutlet weak var imgProfil: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    var userName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let getUser = try! Realm().objects(kontak.self).filter("nama = '\(userName)'").first!
        
        self.imgProfil.setImage(withUrl: URL.init(string: "\(link().gambar)\(getUser.gambar)")!, placeholder: UIImage.init(named: "Avatar"), crossFadePlaceholder: true, cacheScaled: false, completion: nil)
        self.nameLbl.text = getUser.nama
        self.phoneLbl.text = getUser.phone
        self.statusLbl.text = getUser.status
        
        self.setStatusBarStyle(.lightContent)
        
        imgProfil.layer.cornerRadius = 35
        imgProfil.clipsToBounds = true
        imgProfil.layer.borderColor = UIColor.init(hexString: "D9D9D9")?.cgColor
        imgProfil.layer.borderWidth = 1.0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func call(_ sender: UIButton) {
        
        let getUser = try! Realm().objects(kontak.self).filter("nama = '\(userName)'").first!
        
        print(getUser.phone)
        
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
