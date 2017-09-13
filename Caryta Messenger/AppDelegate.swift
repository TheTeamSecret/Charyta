//
//  AppDelegate.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/16/17.
//  Copyright © 2017 Caryta. All rights reserved.
//
import UIKit
import UserNotifications
import PushKit

import Firebase
import FirebaseAuth

import RealmSwift
import SwiftyJSON
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        FirebaseApp.configure()
        
        let schema =  Realm.Configuration.defaultConfiguration.schemaVersion.description
        
        print("Schema : \(schema)")
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 4,
            migrationBlock: { migration, oldSchemaVersion in
                if (Int.init(schema)! < 1) {
                    // The enumerateObjects(ofType:_:) method iterates
                    // over every Person object stored in the Realm file
                    migration.enumerateObjects(ofType: kontak.className()) { oldObject, newObject in
                        // combine name fields into a single field
                        newObject!["phone"] = String()
                    }
                }
                if (Int.init(schema)! < 2) {
                    // The enumerateObjects(ofType:_:) method iterates
                    // over every Person object stored in the Realm file
                    migration.enumerateObjects(ofType: chat.className()) { oldObject, newObject in
                        // combine name fields into a single field
                        newObject!["grup_id"] = String()
                    }
                }
                if (oldSchemaVersion < 3) {
                    // The enumerateObjects(ofType:_:) method iterates
                    // over every Person object stored in the Realm file
                    migration.enumerateObjects(ofType: user.className()) { oldObject, newObject in
                        // combine name fields into a single field
                        newObject!["status"] = String()
                    }
                }
                if (oldSchemaVersion < 4) {
                    // The enumerateObjects(ofType:_:) method iterates
                    // over every Person object stored in the Realm file
                    migration.enumerateObjects(ofType: detail_chat.className()) { oldObject, newObject in
                        // combine name fields into a single field
                        newObject!["picture"] = String()
                    }
                }
        })
        
        _ = try! Realm()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            let action = UNNotificationAction.init(identifier: "reply", title: "Reply", options: [])
            let category = UNNotificationCategory.init(identifier: "myCategory", actions: [action], intentIdentifiers: [], options: [])
            UNUserNotificationCenter.current().setNotificationCategories([category])
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        let getUser = try! Realm().objects(user.self)
        
        let storyboard = UIStoryboard(name: "NewMain", bundle: nil)
        
        if getUser.count > 0 {
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "menu") as! TestMenuBarController
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
        }else{
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "first") as! FirstController
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
        }

        // [END register_for_notifications]
        return true
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        
        print(userInfo)
        
        if Auth.auth().canHandleNotification(userInfo) {
        
            completionHandler(UIBackgroundFetchResult.noData)
            
            return
        
        }
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().shouldEstablishDirectChannel = true
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.sandbox)
        print("APNs token retrieved: \(deviceToken)")
        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
        
        
        
        // With swizzling disabled you must set the APNs token here.
        // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(JSON(userInfo).description)
        
        let get = JSON(userInfo)
        let aps = get["aps"]
        
        print(aps)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(JSON(userInfo).description)
        
        let get = JSON(userInfo)
        let aps = get["aps"]
        
        print(aps)
        
        if get["gcm.notification.group_id"].stringValue != "" {
            
            let getChat     = try! Realm().objects(chat.self).filter("name = '\(aps["alert"]["title"].stringValue)'").first!
            let getKontak   = try! Realm().objects(kontak.self).filter("nama = '\(aps["alert"]["title"].stringValue)'").first!
            
            let modelChat = chat()
            
            let dateFormatter:DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            
            modelChat.chat_id   = getChat.chat_id
            modelChat.avatar    = getChat.avatar
            modelChat.name      = getChat.name
            modelChat.last_chat = aps["alert"]["body"].stringValue
            modelChat.date      = dateFormatter.string(from: Date())
            
            DBHelper.update(obj: modelChat)
            
            let modelDetailChat = detail_chat()
            
            modelDetailChat.chat_id  = getChat.chat_id
            modelDetailChat.user_id  = getKontak.user_id
            modelDetailChat.isi      = get["gcm.notification.isi"].stringValue
            modelDetailChat.avatar   = getChat.avatar
            modelDetailChat.date     = dateFormatter.string(from: Date())
            modelDetailChat.read     = "0"
            
            DBHelper.insert(obj: modelDetailChat)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "menu") as! TestMenuBarController
            let chatVC = storyboard.instantiateViewController(withIdentifier: "detailChat") as! TestDetailChatController
            
            chatVC.chatID = getChat.chat_id
            chatVC.nama = getChat.name
            
            vc.selectedIndex = 3
            
            vc.present(chatVC, animated: true, completion: nil)
        
        }else{
            
            let getChat     = try! Realm().objects(chat.self).filter("name = '\(aps["alert"]["title"].stringValue)'").first!
            let getKontak   = try! Realm().objects(kontak.self).filter("nama = '\(aps["alert"]["title"].stringValue)'").first!
            
            let modelChat = chat()
            
            let dateFormatter:DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            
            modelChat.chat_id   = getChat.chat_id
            modelChat.avatar    = getChat.avatar
            modelChat.name      = getChat.name
            modelChat.last_chat = aps["alert"]["body"].stringValue
            modelChat.date      = dateFormatter.string(from: Date())
            
            DBHelper.update(obj: modelChat)
            
            let modelDetailChat = detail_chat()
            
            modelDetailChat.chat_id  = getChat.chat_id
            modelDetailChat.user_id  = getKontak.user_id
            modelDetailChat.isi      = aps["alert"]["body"].stringValue
            modelDetailChat.avatar   = getChat.avatar
            modelDetailChat.date     = dateFormatter.string(from: Date())
            modelDetailChat.read     = "0"
            
            DBHelper.insert(obj: modelDetailChat)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "menu") as! TestMenuBarController
            let chatVC = storyboard.instantiateViewController(withIdentifier: "detailChat") as! TestDetailChatController
            
            chatVC.chatID = getChat.chat_id
            chatVC.nama = getChat.name
            
            vc.selectedIndex = 3
            
            vc.present(chatVC, animated: true, completion: nil)
        
        }
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    // [END refresh_token]
}
