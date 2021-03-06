//
//  model.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/22/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class link: Object {
    let domain      = "http://api.charytamessenger.com/"
    let subDomain   = "http://api.charytamessenger.com/v1/"
    let domainMain  = "http://api.caryta.com/v1/"
    let gambar      = "http://api.charytamessenger.com/public/images/user/"
    let file        = "https://keep.caryta.com"
    let vid         = "https://drive.caryta.com"
}

class user: Object {
    dynamic var token = ""
    dynamic var user_id = String()
    dynamic var first_name = String()
    dynamic var last_name = String()
    dynamic var email = String()
    dynamic var no_hp = String()
    dynamic var sex = String()
    dynamic var avatar = String()
    dynamic var registrasi_id = String()
    dynamic var status = String()
}

class profil: Object {
    dynamic var showName = String()
    dynamic var status = String()
}

class kontak: Object {
    dynamic var user_id = String()
    dynamic var nama = String()
    dynamic var gambar = String()
    dynamic var status = String()
    dynamic var registrasi_id = String()
    dynamic var phone = String()
    
    override static func primaryKey() -> String? {
        return "user_id"
    }
}

class chat: Object {
    dynamic var chat_id = String()
    dynamic var grup_id = String()
    dynamic var name = String()
    dynamic var last_chat = String()
    dynamic var avatar = String()
    dynamic var date = String()
    
    override static func primaryKey() -> String? {
        return "chat_id"
    }
}

class detail_chat: Object {
    dynamic var chat_id = String()
    dynamic var user_id = String()
    dynamic var isi = String()
    dynamic var avatar = String()
    dynamic var date = String()
    dynamic var picture = String()
    dynamic var read = String()
}
