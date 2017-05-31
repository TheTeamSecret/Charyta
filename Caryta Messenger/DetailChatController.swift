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
    
    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var chatTxt: UITextView!
    
    @IBOutlet weak var ChatViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sentBtn: UIButton!
    
    var nama = ""
    
    var getUser = try! Realm().objects(user.self)[0]
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cell = chatTV.cellForRow(at: indexPath) as! ChatCell
        
        var height: CGFloat = 0.0
        
        if chatID != "" {
            
            let getDetailChat = try! Realm().objects(detail_chat.self).filter("chat_id = '\(chatID)'")
        
            let valueHeight = self.estimateHeightForView(text: getDetailChat[indexPath.row].isi, width: cell.valueLbl.frame.size.width, PointSize: cell.valueLbl.font.pointSize).height
        
            height = 16 + 15 + 10 + valueHeight
            
        }
        
        return height
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var row = 0
        
        if chatID != "" {
        
            let getDetailChat = try! Realm().objects(detail_chat.self).filter("chat_id = '\(chatID)'")
            
            row = getDetailChat.count
            
        }
        
        return row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let getDetailChat = try! Realm().objects(detail_chat.self).filter("chat_id = '\(chatID)'").sorted(byKeyPath: "date")
        
        let cell = chatTV.dequeueReusableCell(withIdentifier: "chatting", for: indexPath) as! ChatCell
        
        cell.userAva.layer.cornerRadius = 5.0
        cell.otherAva.layer.cornerRadius = 5.0
        cell.valueView.layer.cornerRadius = 5.0
        
        cell.userAva.clipsToBounds = true
        cell.otherAva.clipsToBounds = true
        cell.valueView.clipsToBounds = true
        
        if getUser.user_id != getDetailChat[indexPath.row].user_id {
        
            cell.userAva.isHidden = true
            cell.valueView.backgroundColor = UIColor.white
            cell.dateLbl.textAlignment = .right
            cell.statusImg.isHidden = true
            
        }else if getUser.user_id == getDetailChat[indexPath.row].user_id  {
            
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
            
                self.ChatViewHeight.constant = height + 16
            
            }else if 30 > height {
            
                self.ChatViewHeight.constant = 46
            
            }
            
            if chatTxt.text!.characters.count > 0 {
            
                self.sentBtn.isHidden = false
            
            }else if chatTxt.text!.characters.count == 0 {
                
                self.sentBtn.isHidden = true
                
            }
        
        }
        
    }
    
    @IBAction func sentMessage(_ sender: UIButton) {
        
        let params = [
            "to"    : "",
            "from"  : "",
            "text"  : self.chatTxt.text!
        ]
        
        Alamofire.request("\(link().domain)single-notif", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON{response in
        
                if let jason = response.result.value {
                
                    print(JSON(jason).description)
                
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
