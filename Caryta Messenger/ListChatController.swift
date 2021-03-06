//
//  ListChatController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/13/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import RealmSwift
import MapleBacon

class ListChatController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var chatTV: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var addArchiveBtn: UIBarButtonItem!
    @IBOutlet weak var deleteBtn: UIBarButtonItem!
    var isEdit: Bool = false
    @IBOutlet weak var emptyLbl: UILabel!
    
    var sentID = ""
    var sentNama = ""
    let getChat = try! Realm().objects(chat.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarStyle(.lightContent)
        
        chatTV.reloadData()
        //chatTVHeight.constant = chatTV.contentSize.height
        
        if getChat.count == 0 {
//            self.emptyLbl.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTV.dequeueReusableCell(withIdentifier: "chat", for: indexPath) as! ListChatCell
        
        cell.initialLbl.layer.cornerRadius = cell.initialLbl.frame.height / 2
        cell.initialLbl.clipsToBounds = true
        cell.initialLbl.backgroundColor = UIColor.randomFlat
        
        cell.badgeLbl.layer.cornerRadius = cell.badgeLbl.frame.height / 2
        cell.badgeLbl.clipsToBounds = true
        
        let data = self.getChat[indexPath.row]
        
        cell.nameLbl.text = data.name
        cell.lastLbl.text = data.last_chat
        cell.timeLbl.text = getChat[indexPath.row].date
        
        let initIndex = data.name.index(data.name.startIndex, offsetBy: 1)
        let initial = data.name.substring(to: initIndex).uppercased()
        
        cell.initialLbl.text = initial
        
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
        self.sentID = getChat[indexPath.row].chat_id
        self.sentNama = getChat[indexPath.row].name
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
    
    @IBAction func btnNewChatTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showNewChat", sender: self)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        self.view.endEditing(true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_detail_chat" {
            let next = segue.destination as! DetailChatController
            next.chatID = self.sentID
            next.nama = self.sentNama
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
