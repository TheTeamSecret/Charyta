//
//  TestListTeleponController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/13/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class TestListTeleponController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var phoneTV: UITableView!
    
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var addDeleteBtn: UIBarButtonItem!
    var isEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = phoneTV.dequeueReusableCell(withIdentifier: "phone", for: indexPath) as! TestListPhoneCell
        
        cell.initialLbl.layer.cornerRadius = 20
        cell.initialLbl.clipsToBounds = true
        
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
    
    @IBAction func editAct(_ sender: UIBarButtonItem) {
        
        if sender.title == "Edit" {
        
            addDeleteBtn.image = UIImage.init(named: "hapus")
            isEdit = true
            editBtn.title = "Cancel"
            phoneTV.reloadData()
        
        }else if sender.title == "Cancel" {
            
            addDeleteBtn.image = UIImage.init(named: "make_a_call")
            isEdit = false
            editBtn.title = "Edit"
            phoneTV.reloadData()
            
        }
        
    }
    
    @IBAction func selctDeselect(_ sender: UIButton) {
        
        if sender.imageView?.image == UIImage.init(named: "select") {
        
            sender.setImage(UIImage.init(named: "select_blue"), for: .normal)
        
        }else if sender.imageView?.image == UIImage.init(named: "select_blue") {
            
            sender.setImage(UIImage.init(named: "select"), for: .normal)
            
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
