//
//  TestListChatController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/13/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class TestListChatController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var chatTV: UITableView!
    
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var addArchiveBtn: UIBarButtonItem!
    @IBOutlet weak var deleteBtn: UIBarButtonItem!
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
        
        let cell = chatTV.dequeueReusableCell(withIdentifier: "chat", for: indexPath) as! TestListChatCell
        
        cell.initialLbl.layer.cornerRadius = 20
        cell.initialLbl.clipsToBounds = true
        
        cell.badgeLbl.layer.cornerRadius = 9
        cell.badgeLbl.clipsToBounds = true
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        self.performSegue(withIdentifier: "segue_detail_chat", sender: self)
        
    }
    
    @IBAction func editAct(_ sender: UIBarButtonItem) {
        
        if sender.title == "Edit" {
            
            addArchiveBtn.image = UIImage.init(named: "archive")
            deleteBtn.image = UIImage.init(named: "hapus")
            isEdit = true
            editBtn.title = "Cancel"
            chatTV.reloadData()
            
        }else if sender.title == "Cancel" {
            
            addArchiveBtn.image = UIImage.init(named: "add_chat")
            deleteBtn.image = nil
            isEdit = false
            editBtn.title = "Edit"
            chatTV.reloadData()
            
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
