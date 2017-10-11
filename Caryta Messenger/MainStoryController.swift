//
//  MainStoryController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 9/18/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class MainStoryController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myStoryTV: UITableView!
    @IBOutlet weak var myStoryTVHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var storyID = [String]()
    var userID = [String]()
    var isi = [String]()
    var viewers = [String]()
    
    func getMyStory() {
        let getUser = try! Realm().objects(user.self).first!
        Alamofire.request("\(link().subDomain)user/story", method: .get, encoding: JSONEncoding.default, headers: ["kodeUser": getUser.user_id, "Content-Type": "application/json"])
            .responseJSON{response in
                if let jason = response.result.value {
                    if JSON(jason)["kode_user"].stringValue == getUser.user_id {
                        for data in JSON(jason).array! {
                            self.storyID.append(data["id_story"].stringValue)
                            self.userID.append(data["kode_user"].stringValue)
                            self.isi.append(data["isi"].stringValue)
                            self.viewers.append(data["jumlah_lihat"].stringValue)
                        }
                        self.myStoryTV.reloadData()
                        self.myStoryTVHeight.constant = self.myStoryTV.contentSize.height
                    }
                }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storyID.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.myStoryTV.dequeueReusableCell(withIdentifier: "story", for: indexPath) as! MyStoryCell
            cell.seenLbl.text = self.viewers[indexPath.row]
        return cell
    }
    
}
