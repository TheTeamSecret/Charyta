//
//  DBHelper.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/22/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

struct DBHelper {
    
    static func insert(obj: Object){
        
        try! Realm().write(){
            
            try! Realm().add(obj)
            
        }
        
    }
    
    static func update(obj: Object){
        
        try! Realm().write(){
            
            try! Realm().add(obj, update: true)
            
        }
        
    }
    
    static func delete(obj: Object){
        
        try! Realm().write(){
            
            try! Realm().delete(obj)
            
        }
        
    }
    
}

struct firebaseHelper {
        
        func sendChat(_ token: String, nama: String, isi: String) {
        
        var request = URLRequest(url: URL(string: "https://fcm.googleapis.com/fcm/send")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAVLLQtxM:APA91bGS8w6GjsrDqiR8zorSN8F5AeK4PS3W3G08fUrOGEer07PK0pZ96KtrHmvz69CiU9stQBUsTXiyvmnZPfrLks0vzaJ-whV2ppEIxvJfg8ex_zo9SO9Wh2varAWiSWeXijXXkQ91", forHTTPHeaderField: "Authorization")
        let json = [
            "to" : token,
            "priority" : "high",
            "notification" : [
                "title": nama,
                "body" : isi
            ]
            ] as [String : Any]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error=\(error!)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    // check for http errors
                    print("Status Code should be 200, but is \(httpStatus.statusCode)")
                    print("Response = \(response!)")
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString!)")
            }
            task.resume()
        }
        catch {
            print(error)
        }
        
    }
    
}
