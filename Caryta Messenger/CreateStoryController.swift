//
//  CreateStoryController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 9/18/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class CreateStoryController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var storyTxt: UITextView!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
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
        
        storyTxt.delegate = self
        storyTxt.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateStoryController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateStoryController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == storyTxt {
            let arbitraryValue: Int = 6
            if let newPosition = storyTxt.position(from: storyTxt.beginningOfDocument, offset: arbitraryValue) {
                
                storyTxt.selectedTextRange = storyTxt.textRange(from: newPosition, to: newPosition)
            }
            print(storyTxt.selectedRange.location)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == storyTxt {
            print("0", storyTxt.text, storyTxt.textColor!.hexValue())
            if storyTxt.text != "Type a status" && storyTxt.textColor!.hexValue() == "#676767" {
                storyTxt.textColor = UIColor.white
                let newTxt = textView.text.replacingOccurrences(of: "Type a", with: "").replacingOccurrences(of: " status", with: "")
                let upTxt = newTxt.uppercased()
                storyTxt.text = upTxt
            }else if storyTxt.text == "" && storyTxt.textColor == UIColor.white {
                storyTxt.textColor = UIColor.init(hexString: "676767")
                storyTxt.text = "Type a status"
                let arbitraryValue: Int = 6
                if let newPosition = storyTxt.position(from: storyTxt.beginningOfDocument, offset: arbitraryValue) {
                    
                    storyTxt.selectedTextRange = storyTxt.textRange(from: newPosition, to: newPosition)
                }
                print(storyTxt.selectedRange.location)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sentStory(_ sender: UIButton) {
        let getUser = try! Realm().objects(user.self).first!
        Alamofire.request("\(link().subDomain)user/story", method: .post, parameters: ["isi": self.storyTxt.text], encoding: JSONEncoding.default, headers: ["kodeUser": getUser.user_id, "Content-Type": "application/json"])
            .responseJSON{response in
                if let jason = response.result.value {
                    print(JSON(jason).description)
                    self.dismiss(animated: true, completion: nil)
                }
        }
    }
    
}
