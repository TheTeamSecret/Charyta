//
//  WritePostController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/15/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class WritePostController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    @IBOutlet weak var postTxt: UITextView!
    
    var imgName = String()
    var imgURL : URL!
    
    var picker:UIImagePickerController?=UIImagePickerController()
    
    @IBAction func openCamera(_ sender: UIButton) {
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker = UIImagePickerController()
            picker!.delegate = self;
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            picker!.allowsEditing = true
            picker!.videoMaximumDuration = 15
            self.present(picker!, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func openGallery(_ sender: UIButton) {
        
        picker = UIImagePickerController()
        picker!.delegate = self;
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker!.allowsEditing = true
        picker!.videoMaximumDuration = 15
        
        self.present(picker!, animated: true, completion: nil)
    }
    
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
        
        self.setStatusBarStyle(.lightContent)
        
        postTxt.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(WritePostController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WritePostController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let myPicture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //self.ktpImg.image = myPicture
            
            let imageName = NSUUID().uuidString.replacingOccurrences(of: "-", with: "")
            
            let imagePath = getDocumentsDirectory().appendingPathComponent("\(imageName).jpg")
            
            print(imagePath)
            
            let jpegData = UIImageJPEGRepresentation(myPicture, 0.5)
            
            let imageURL = URL.init(fileURLWithPath: imagePath)
            
            try? jpegData!.write(to: imageURL, options: .atomic)
            
            imgName = imageURL.lastPathComponent
            
            imgURL = imageURL
            
            print(imgName)
            
            picker.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    func post() {
        
        let getUser = try! Realm().objects(user.self).first!
        
        if imgName != "" {
        
            Alamofire.upload(multipartFormData: { multipartFormData in
                
                multipartFormData.append(self.imgURL, withName: "file")
                multipartFormData.append(getUser.user_id.data(using: String.Encoding.utf8)!, withName: "kode_user")
                multipartFormData.append(self.postTxt.text.data(using: String.Encoding.utf8)!, withName: "caption")
                
            }, to: URL(string: "\(link().domain)add-timeline")!, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        self.dismiss(animated: true, completion: nil)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            })
        
        }else{
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                
                multipartFormData.append(getUser.user_id.data(using: String.Encoding.utf8)!, withName: "kode_user")
                multipartFormData.append(self.postTxt.text.data(using: String.Encoding.utf8)!, withName: "caption")
                
            }, to: URL(string: "\(link().domain)add-timeline")!, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        self.dismiss(animated: true, completion: nil)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            })
        
        }
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
