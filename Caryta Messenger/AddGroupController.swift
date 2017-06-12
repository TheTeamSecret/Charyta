//
//  AddGroupController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/8/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import Firebase
import MapleBacon

class AddGroupController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var grupImg: UIImageView!
    @IBOutlet weak var grupSubjek: UITextField!
    @IBOutlet weak var participantCV: UICollectionView!
    
    var idArray = [String]()
    
    var sentID = ""
    var sentgroupID = ""
    var sentName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        grupSubjek.addBorder(side: .top, thickness: 1.0, color: .lightGray)
        grupSubjek.addBorder(side: .bottom, thickness: 1.0, color: .lightGray)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.participantCV.frame.size.width / 3) - 8
        let height = width * 5 / 4
        
        return CGSize.init(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = participantCV.dequeueReusableCell(withReuseIdentifier: "part", for: indexPath) as! ParticipantCell
        
        let getKontak = try! Realm().objects(kontak.self).filter("user_id = '\(idArray[indexPath.row])'").first!
        
        cell.avaImg.setImage(withUrl: URL.init(string: "\(link().gambar)\(getKontak.gambar)")!, placeholder: UIImage.init(named: "Avatar"), crossFadePlaceholder: true, cacheScaled: false, completion: nil)
        cell.nickLbl.text = getKontak.nama
        
        return cell
        
    }
    
    @IBAction func createGroup(_ sender: UIBarButtonItem) {
        
        let imageData = UIImagePNGRepresentation(self.grupImg.image!)
        let base64String = imageData!.base64EncodedString(options: .lineLength64Characters)
        
        let params = [
            "name"  : self.grupSubjek.text!
        ]
        
        Alamofire.request("\(link().domain)name", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON{response in
        
                if let jason = response.result.value {
                
                    print(JSON(jason).description)
                    
                    Messaging.messaging().subscribe(toTopic: JSON(jason)["data"]["groupId"].stringValue)
                    
                    let getChat = try! Realm().objects(chat.self)
                    
                    let modKontak = kontak()
                    
                    modKontak.user_id       = JSON(jason)["data"]["groupId"].stringValue
                    modKontak.nama          = self.grupSubjek.text!
                    modKontak.gambar        = ""
                    modKontak.status        = "Group"
                    modKontak.registrasi_id = JSON(jason)["data"]["groupId"].stringValue
                    modKontak.phone         = ""
                    
                    DBHelper.update(obj: modKontak)
                    
                    let model = chat()
                    
                    model.chat_id   = "\(getChat.count + 1)"
                    model.grup_id   = JSON(jason)["data"]["groupId"].stringValue
                    model.name      = self.grupSubjek.text!
                    model.last_chat = "You created this group"
                    model.avatar    = ""
                    model.date      = ""
                    
                    DBHelper.update(obj: model)
                    
                    self.sentID         = "\(getChat.count + 1)"
                    self.sentName       = self.grupSubjek.text!
                    self.sentgroupID    = JSON(jason)["data"]["groupId"].stringValue
                    
                    self.performSegue(withIdentifier: "goToChat", sender: self)
                    
                
                }
                
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToChat" {
        
            let next = segue.destination as! DetailChatController
            
            next.chatID     = self.sentID
            next.nama       = self.sentName
            next.groupID    = self.sentgroupID
        
        }
        
    }

}
