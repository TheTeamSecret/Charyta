//
//  ListTeleponController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/13/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class ListTeleponController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var phoneTV: UITableView!
    
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var addDeleteBtn: UIBarButtonItem!
    var isEdit: Bool = false
    
    var nameDummy = ["Silmy Tama", "Om Bob", "Gustang", "Gustang", "Ari Maulana", "Ilham Sabar"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarStyle(.lightContent)

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
        return nameDummy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = phoneTV.dequeueReusableCell(withIdentifier: "phone", for: indexPath) as! ListPhoneCell
        
        cell.initialLbl.layer.cornerRadius = 20
        cell.initialLbl.clipsToBounds = true
        
        cell.nameLbl.text = self.nameDummy[indexPath.row]
        
        let initIndex = nameDummy[indexPath.row].index(nameDummy[indexPath.row].startIndex, offsetBy: 1)
        let initial = nameDummy[indexPath.row].substring(to: initIndex).uppercased()
        
        let mod = (indexPath.row + 1) % 2
        
        if mod == 1 {
        
            cell.typeImg.image = UIImage.init(named: "tlpnkeluar")
        
        }else{
            
            cell.typeImg.image = UIImage.init(named: "telpn merah")
        
        }
        
        cell.initialLbl.text = initial
        
        cell.initialLbl.backgroundColor = UIColor.randomFlat
        
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
