//
//  DetailChatController.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/17/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON
import RealmSwift
import MapleBacon

class DetailChatController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    @IBOutlet weak var chatTV: UITableView!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var chatTxt: UITextView!
    
    @IBOutlet weak var ChatViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sentBtn: UIButton!
    
    var nama = ""
    
    var groupID = ""
    
    var row = 0
    
    var getUser = try! Realm().objects(user.self).first!
    
    var chatID = ""
    
    func keyboardWillShow(_ notification : NSNotification) {
        
        let keyBoardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        self.bottom.constant = keyBoardSize.height
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        
    }
    
    func keyboardWillHide(_ notification : Notification) {
        
        self.bottom.constant = 0.0
        
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(getUser)
        
        let getDetailChat = try! Realm().objects(detail_chat.self).filter("chat_id = '\(chatID)'")
        
        print(getDetailChat)
        
        self.chatTV.estimatedRowHeight = 87
        self.chatTV.rowHeight = UITableViewAutomaticDimension
        
        self.navItem.title = self.nama
        
        self.chatTxt.layer.cornerRadius = 15.0
        self.chatTxt.layer.borderWidth = 1.0
        self.chatTxt.layer.borderColor = UIColor.init(hexString: "F1F1F1")!.cgColor
        
        voiceBtn.layer.borderWidth = 0.5
        voiceBtn.layer.borderColor = UIColor.init(hexString: "F1F1F1")!.cgColor
        voiceBtn.layer.cornerRadius = 7.5
        
        sentBtn.layer.cornerRadius = 7.5
        
        addBtn.layer.borderWidth = 0.5
        addBtn.layer.borderColor = UIColor.init(hexString: "F1F1F1")!.cgColor
        addBtn.layer.cornerRadius = 7.5
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailChatController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailChatController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.setStatusBarStyle(.lightContent)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let item = self.tableView(self.chatTV, numberOfRowsInSection: 0) - 1
        
        let lastItem = IndexPath.init(row: item, section: 0)
        
        self.chatTV.scrollToRow(at: lastItem, at: .bottom, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if chatID != "" {
            
            let getDetailChat = try! Realm().objects(detail_chat.self)
            
            print(getDetailChat.count)
            
            row = getDetailChat.count
            
        }
        
        return row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let getDetailChat = try! Realm().objects(detail_chat.self).filter("chat_id = '\(chatID)'")
        
        let cell = chatTV.dequeueReusableCell(withIdentifier: "chatting", for: indexPath) as! ChatCell
        
        cell.userAva.layer.cornerRadius = 5.0
        cell.otherAva.layer.cornerRadius = 5.0
        cell.valueView.layer.cornerRadius = 5.0
        
        cell.userAva.clipsToBounds = true
        cell.otherAva.clipsToBounds = true
        cell.valueView.clipsToBounds = true
        
        let newHeight = self.estimateHeightForView(text: getDetailChat[indexPath.row].isi, width: cell.valueLbl.frame.size.width, PointSize: 14.0).height
        
        if newHeight < 25 {
            
            cell.valueViewHeight.constant = 25 + 18
        
        }else if newHeight > 25 {
            
            cell.valueViewHeight.constant = newHeight + 18
        
        }
        
        if getUser.user_id != getDetailChat[indexPath.row].user_id {
            
            cell.otherAva.setImage(withUrl: URL.init(string: "\(link().gambar)\(getDetailChat[indexPath.row].avatar)")!, placeholder: UIImage.init(named: "Avatar"), crossFadePlaceholder: true, cacheScaled: false, completion: nil)
        
            cell.userAva.isHidden = true
            cell.valueView.backgroundColor = UIColor.white
            cell.dateLbl.textAlignment = .right
            cell.statusImg.isHidden = true
            
        }
        
        if getUser.user_id == getDetailChat[indexPath.row].user_id  {
            
            cell.userAva.setImage(withUrl: URL.init(string: "\(link().gambar)\(getUser.avatar)")!, placeholder: UIImage.init(named: "Avatar"), crossFadePlaceholder: true, cacheScaled: false, completion: nil)
            
            cell.otherAva.isHidden = true
            cell.valueView.backgroundColor = UIColor.init(hexString: "91D4F6")
            cell.dateLbl.textAlignment = .left
        
        }
        
        cell.valueLbl.text = getDetailChat[indexPath.row].isi
        cell.dateLbl.text = getDetailChat[indexPath.row].date
        
        return cell
        
    }
    
    @IBAction func goToDetailProfil(_ sender: UIBarButtonItem) {
        
        self.performSegue(withIdentifier: "segue_detail_profil", sender: self)
        
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: self.chatTxt.frame.size.width, height: 10000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
    private func estimateHeightForView(text: String, width: CGFloat, PointSize: CGFloat) -> CGRect {
        let size = CGSize(width: width, height: 10000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: PointSize)], context: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView == chatTxt {
        
            let height = self.estimateFrameForText(text: chatTxt.text!).height
            
            if height > 30 {
            
                self.ChatViewHeight.constant = height + 33
                
                UIView.animate(withDuration: 0.3, animations: {
                
                    self.view.layoutIfNeeded()
                
                })
            
            }else if 30 > height {
            
                self.ChatViewHeight.constant = 46
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.view.layoutIfNeeded()
                    
                })
            
            }
            
            if chatTxt.text!.characters.count > 0 {
            
                self.sentBtn.isHidden = false
            
            }else if chatTxt.text!.characters.count == 0 {
                
                self.sentBtn.isHidden = true
                
            }
        
        }
        
    }
    
    @IBAction func sentMessage(_ sender: UIButton) {
        
        let isi = self.chatTxt.text!

        let getKontak = try! Realm().objects(kontak.self).filter("nama = '\(self.nama)'").first!
        
        let getChat = try! Realm().objects(chat.self)
        
        print(getChat)
        
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        if groupID != "" {
            
            let filter = getChat.filter("grup_id = '\(self.groupID)'")
            
            let model = chat()
            
            model.chat_id   = filter.first!.chat_id
            model.grup_id   = self.groupID
            model.name      = self.nama
            model.last_chat = isi
            model.avatar    = filter.first!.avatar
            model.date      = dateFormatter.string(from: Date())
            
            DBHelper.update(obj: model)
            
            let model1 = detail_chat()
            
            model1.chat_id  = getChat.first!.chat_id
            model1.user_id  = self.getUser.user_id
            model1.isi      = isi
            model1.avatar   = self.getUser.avatar
            model1.date     = dateFormatter.string(from: Date())
            model1.read     = "0"
            
            DBHelper.insert(obj: model1)
            
            self.chatTV.reloadData()
            
            self.chatTV.estimatedRowHeight = 80
            self.chatTV.rowHeight = UITableViewAutomaticDimension
            
            let item = self.tableView(self.chatTV, numberOfRowsInSection: 0) - 1
            
            let lastItem = IndexPath.init(row: item, section: 0)
            
            self.chatTV.scrollToRow(at: lastItem, at: .bottom, animated: true)
            
            let headers = [
                "Content-Type": "application/json",
                "Authorization": "key=AAAAVLLQtxM:APA91bGS8w6GjsrDqiR8zorSN8F5AeK4PS3W3G08fUrOGEer07PK0pZ96KtrHmvz69CiU9stQBUsTXiyvmnZPfrLks0vzaJ-whV2ppEIxvJfg8ex_zo9SO9Wh2varAWiSWeXijXXkQ91"
            ]
            
            let params = [
                "to" : "/topics/\(self.groupID)",
                "priority" : "high",
                "notification" : [
                    "body" : "\(getUser.first_name) : \(isi)",
                    "title" : self.nama,
                    "group_id" : self.groupID,
                    "user_id" : self.getUser.user_id,
                    "no_hp" : self.getUser.no_hp,
                    "isi" : isi
                ]
            ] as [String : Any]
            
            self.chatTxt.text = ""
            
            Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .responseJSON{response in
                    
                    if let jason = response.result.value {
                        
                        print(JSON(jason).description)
                        
                    }
            
            }
        
        }else{
            
            if getChat.count > 0 {
                
                let filter = getChat.filter("name = '\(self.nama)'")
                
                let model = chat()
                
                model.chat_id   = filter.first!.chat_id
                model.grup_id   = ""
                model.name      = self.nama
                model.last_chat = isi
                model.avatar    = filter.first!.avatar
                model.date      = dateFormatter.string(from: Date())
                
                DBHelper.update(obj: model)
                
                let model1 = detail_chat()
                
                model1.chat_id  = getChat.first!.chat_id
                model1.user_id  = self.getUser.user_id
                model1.isi      = isi
                model1.avatar   = self.getUser.avatar
                model1.date     = dateFormatter.string(from: Date())
                model1.read     = "0"
                
                DBHelper.insert(obj: model1)
                
                self.chatTV.reloadData()
                
                self.chatTV.estimatedRowHeight = 80
                self.chatTV.rowHeight = UITableViewAutomaticDimension
                
                let item = self.tableView(self.chatTV, numberOfRowsInSection: 0) - 1
                
                let lastItem = IndexPath.init(row: item, section: 0)
                
                self.chatTV.scrollToRow(at: lastItem, at: .bottom, animated: true)
                
            }else{
                
                let getKontak = try! Realm().objects(kontak.self).filter("nama = '\(self.nama)'")
                
                let newID = "\(getChat.count + 1)"
                
                let model = chat()
                
                model.chat_id   = newID
                model.grup_id   = ""
                model.name      = self.nama
                model.last_chat = isi
                model.avatar    = getKontak.first!.gambar
                model.date      = dateFormatter.string(from: Date())
                
                DBHelper.update(obj: model)
                
                let model1 = detail_chat()
                
                model1.chat_id  = newID
                model1.user_id  = self.getUser.user_id
                model1.isi      = isi
                model1.avatar   = self.getUser.avatar
                model1.date     = dateFormatter.string(from: Date())
                model1.read     = "0"
                
                DBHelper.insert(obj: model1)
                
                self.chatTV.reloadData()
                
                self.chatTV.estimatedRowHeight = 80
                self.chatTV.rowHeight = UITableViewAutomaticDimension
                
                let item = self.tableView(self.chatTV, numberOfRowsInSection: 0) - 1
                
                let lastItem = IndexPath.init(row: item, section: 0)
                
                self.chatTV.scrollToRow(at: lastItem, at: .bottom, animated: true)
                
            }
            
            let params = [
                "to"    : getKontak.user_id,
                "from"  : getUser.user_id,
                "text"  : isi
            ]
            
            self.chatTxt.text = ""
            
            Alamofire.request("\(link().domain)single-notif", method: .post, parameters: params, encoding: JSONEncoding.default)
                .responseJSON{response in
                    
                    if let jason = response.result.value {
                        
                        print(JSON(jason).description)
                        
                        
                        
                    }
                    
            }
        
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue_detail_profil" {
        
            let next = segue.destination as! DetailKontakController
            
            next.userName = self.nama
        
        }
        
    }

}
