//
//  DetailChatController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/14/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class DetailChatController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var initialLbl: UILabel!
    
    @IBOutlet weak var detailChatTV: UITableView!
    @IBOutlet weak var detailChatTVHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    @IBOutlet weak var chatViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chatTxt: UITextView!
    
    var nama = ""
    var row = 0
    var getUser = try! Realm().objects(user.self)[0]
    var groupID = ""
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
        
        self.chatTxt.layer.cornerRadius = 15.0
        self.chatTxt.layer.borderWidth = 1.0
        self.chatTxt.layer.borderColor = UIColor.init(hexString: "F1F1F1")!.cgColor
        
//        self.voiceBtn.layer.borderWidth = 0.5
//        self.voiceBtn.layer.borderColor = UIColor.init(hexString: "F1F1F1")!.cgColor
//        self.voiceBtn.layer.cornerRadius = 7.5
//        self.sentBtn.layer.cornerRadius = 7.5
//        self.addBtn.layer.borderWidth = 0.5
//        self.addBtn.layer.borderColor = UIColor.init(hexString: "F1F1F1")!.cgColor
//        self.addBtn.layer.cornerRadius = 7.5
        
        self.setStatusBarStyle(.lightContent)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailChatController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailChatController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        initialLbl.layer.cornerRadius = 20
        initialLbl.clipsToBounds = true
        
        self.detailChatTV.estimatedRowHeight = 46
        self.detailChatTV.rowHeight = UITableViewAutomaticDimension
        
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(DetailChatController.endEdit))
        tapBack.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapBack)
        
        if chatID != "" {
            let getDetailChat = try! Realm().objects(detail_chat.self)
            row = getDetailChat.count
        }
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
        return self.row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailChatTV.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as! DetailChatCell
        
        let getDetailChat = try! Realm().objects(detail_chat.self).filter("chat_id = '\(chatID)'").sorted(byKeyPath: "date")
        
        let txt = getDetailChat[indexPath.row].isi
        cell.timeLbl.text = getDetailChat[indexPath.row].date
        
        if getUser.user_id != getDetailChat[indexPath.row].user_id {
            cell.blueView.removeFromSuperview()
            cell.readReceipt.removeFromSuperview()
            cell.whiteLbl.text = txt
            let newWidth = self.estimatewidthForView(text: txt).width
            let newHeight = self.estimateHeightForView(text: txt).height
            cell.whiteWidth.constant = 20 + newWidth
            cell.whiteHeight.constant = 20 + newHeight
            cell.whiteView.layer.cornerRadius = 0.0
            let maskPath = UIBezierPath(roundedRect: CGRect.init(origin: cell.whiteView.bounds.origin, size: CGSize.init(width: 16 + newWidth, height: 16 + newHeight)), byRoundingCorners: [.topLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: 15.0, height: 15.0))
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            cell.whiteView.layer.mask = maskLayer
        }
        if getUser.user_id == getDetailChat[indexPath.row].user_id  {
            cell.whiteView.removeFromSuperview()
            cell.blueLbl.text = txt
            let newWidth = self.estimatewidthForView(text: txt).width
            let newHeight = self.estimateHeightForView(text: txt).height
            cell.blueWidth.constant = 20 + newWidth
            cell.blueHeight.constant = 20 + newHeight
            cell.blueView.layer.cornerRadius = 0.0
            let maskPath = UIBezierPath(roundedRect: CGRect.init(origin: cell.blueView.bounds.origin, size: CGSize.init(width: 16 + newWidth, height: 16 + newHeight)), byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize(width: 15.0, height: 15.0))
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            cell.blueView.layer.mask = maskLayer
        }
        
        detailChatTVHeight.constant = detailChatTV.contentSize.height
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = self.detailChatTV.cellForRow(at: indexPath) as! DetailChatCell
        let getDetailChat = try! Realm().objects(detail_chat.self).filter("chat_id = '\(chatID)'").sorted(byKeyPath: "date")
        var height: CGFloat = 0.0
        if chatID != "" {
            if getUser.user_id != getDetailChat[indexPath.row].user_id  {
                let getDetailChat = try! Realm().objects(detail_chat.self).filter("chat_id = '\(chatID)'")
                let valueHeight = self.estimateHeightForViewContainer(text: getDetailChat[indexPath.row].isi, width: cell.whiteView.frame.width, PointSize: cell.whiteLbl.font.pointSize).height
                height = 16 + 15 + 10 + valueHeight
            }
            if getUser.user_id == getDetailChat[indexPath.row].user_id  {
                let getDetailChat = try! Realm().objects(detail_chat.self).filter("chat_id = '\(chatID)'")
                let valueHeight = self.estimateHeightForViewContainer(text: getDetailChat[indexPath.row].isi, width: cell.blueView.frame.width, PointSize: cell.blueLbl.font.pointSize).height
                height = 16 + 15 + 10 + valueHeight
            }
        }
        return height
    }
    
    private func estimatewidthForView(text: String) -> CGRect {
        let size = CGSize(width: (self.view.frame.size.width - 100), height: 14)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)], context: nil)
    }
    
    private func estimateHeightForView(text: String) -> CGRect {
        let size = CGSize(width: (self.view.frame.size.width - 100), height: 10000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)], context: nil)
    }
    
    private func estimateHeightForViewContainer(text: String, width: CGFloat, PointSize: CGFloat) -> CGRect {
        let size = CGSize(width: width, height: 10000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: PointSize)], context: nil)
    }
    
    func endEdit() {
        self.view.endEditing(true)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: self.chatTxt.frame.size.width, height: 10000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == chatTxt {
            let height = self.estimateFrameForText(text: chatTxt.text!).height
            if height > 30 {
                self.chatViewHeight.constant = height + 33
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }else if 30 > height {
                self.chatViewHeight.constant = 46
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @IBAction func sentAct(_ sender: UIButton) {
        self.sentMessage()
    }
    
    func sentMessage() {
        let isi = self.chatTxt.text!
        let getKontak = try! Realm().objects(kontak.self).filter("nama = '\(self.nama)'").first!
        let getChat = try! Realm().objects(chat.self)
        
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        //Group
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
            
            self.scroolToLast()
            self.sendGroup()
        }else{
            //Personal
            if getChat.count > 0 {
                let filter = getChat.filter("name = '\(self.nama)'").first!
                let model = chat()
                model.chat_id   = filter.chat_id
                model.grup_id   = ""
                model.name      = self.nama
                model.last_chat = isi
                model.avatar    = filter.avatar
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
                
                self.scroolToLast()
            }else{
                let newID = "\(getChat.count + 1)"
                
                let model = chat()
                model.chat_id   = newID
                model.grup_id   = ""
                model.name      = self.nama
                model.last_chat = isi
                model.avatar    = getKontak.gambar
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
                
                self.scroolToLast()
            }
            self.sendSingle()
        }
    }
    
    func scroolToLast(){
        self.detailChatTV.reloadData()
        self.detailChatTV.estimatedRowHeight = 80
        self.detailChatTV.rowHeight = UITableViewAutomaticDimension
        let item = self.tableView(self.detailChatTV, numberOfRowsInSection: 0) - 1
        let lastItem = IndexPath.init(row: item, section: 0)
        self.detailChatTV.scrollToRow(at: lastItem, at: .bottom, animated: true)
    }
    
    func sendSingle(){
        let getKontak = try! Realm().objects(kontak.self).filter("nama = '\(self.nama)'").first!
        let isi = self.chatTxt.text!
        let head = [
            "kodeUser" : getUser.user_id,
            "Content-Type" : "application/json"
        ]
        let params = [
            "userKe"    : getKontak.user_id,
            "pesan"  : isi
        ]
        self.chatTxt.text = ""
        Alamofire.request("\(link().subDomain)chat/single", method: .post, parameters: params, encoding: JSONEncoding.default, headers: head)
            .responseJSON{response in
                if let jason = response.result.value {
                    print(JSON(jason).description)
                }
        }
    }
    
    func sendGroup(){
        let isi = self.chatTxt.text!
        let head = [
            "kodeUser" : getUser.user_id,
            "Content-Type" : "application/json"
        ]
        let params = [
            "kodeGroup" : self.groupID,
            "pesan" : isi
        ]
        self.chatTxt.text = ""
        Alamofire.request("\(link().subDomain)chat/group", method: .post, parameters: params, encoding: JSONEncoding.default, headers: head)
            .responseJSON{response in
                if let jason = response.result.value {
                    print(JSON(jason).description)
                }
        }
    }
    
    func sendGroupOld(){
        let isi = self.chatTxt.text!
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
    }
    

}
