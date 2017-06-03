//
//  ListChatController.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/16/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import RealmSwift
import MapleBacon

class ListChatController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var listChatTV: UITableView!
    @IBOutlet weak var listChatTVHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var emptyLbl: UILabel!
    
    var sentID = String()
    var sentNama = String()
    
    let getChat = try! Realm().objects(chat.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarStyle(.lightContent)
        
        listChatTV.reloadData()
        listChatTVHeight.constant = listChatTV.contentSize.height
        
        if getChat.count == 0 {
        
            self.emptyLbl.isHidden = false
        
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        listChatTV.reloadData()
        
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
        
        let cell = listChatTV.dequeueReusableCell(withIdentifier: "chat", for: indexPath) as! ListChatCell
        
        cell.avatarImg.layer.cornerRadius = 5.0
        cell.badge.layer.cornerRadius = 6.0
        cell.badge.clipsToBounds = true
        
        cell.nameLbl.text = getChat[indexPath.row].name
        cell.lastLbl.text = getChat[indexPath.row].last_chat
        cell.dateLbl.text = getChat[indexPath.row].date
        
        return cell
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(false, animated: true)
        self.view.endEditing(true)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.sentID = getChat[indexPath.row].chat_id
        self.sentNama = getChat[indexPath.row].name
        
        self.performSegue(withIdentifier: "segue_detail_chat", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue_detail_chat" {
        
            let next = segue.destination as! DetailChatController
            
            next.chatID = self.sentID
            next.nama = self.sentNama
        
        }
        
    }

}
