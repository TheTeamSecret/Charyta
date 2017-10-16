//
//  Helper.swift
//  Caryta Messenger
//
//  Created by Caryta on 16/10/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Helper{
    static let token = InstanceID.instanceID().token()!
    
    static func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
}
