//
//  TestPopUpUbahDataController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/17/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class TestPopUpUbahDataController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var itemTF: UITextField!
    
    var oldItem = ""
    
    var from = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTF.text = oldItem
        
        self.showAnimate()
        
        self.containerView.layer.cornerRadius = 10
        
        itemTF.becomeFirstResponder()
        
        if from == "nama" {
            
            self.typeLbl.text = "Ubah Nama"
            
        }
        
        if from == "status" {
            
            self.typeLbl.text = "Ubah Status"
            
        }
        
        if from == "email" {
            
            self.typeLbl.text = "Ubah Email"
            
        }
        
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(TestPopUpUbahDataController.closePopup))
        tapBack.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapBack)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closePopup(){
        self.removeAnimate()
    }
    
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0.0
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: {(finished: Bool) in
            if(finished){
                self.view.removeFromSuperview()
            }
        })
    }
    
    @IBAction func finish(_ sender: UITextField) {
        
        let myParent = self.parent as! TestMenuBarController
        let profilNC = myParent.selectedViewController as! UINavigationController
        let profilVC = profilNC.viewControllers.first as! TestProfilController
        
        if from == "nama" {
        
            profilVC.nameLbl.text = self.itemTF.text!
            closePopup()
        
        }
        
        if from == "status" {
            
            profilVC.statusLbl.text = self.itemTF.text!
            closePopup()
            
        }
        
        if from == "email" {
            
            profilVC.emailLbl.text = self.itemTF.text!
            closePopup()
            
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
