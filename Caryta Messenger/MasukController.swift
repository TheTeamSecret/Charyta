//
//  MasukController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 5/30/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import SwiftyJSON
import Firebase

class MasukController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imgName = ""
    
    var fileURL: URL!
    
    var picker:UIImagePickerController?=UIImagePickerController()
    
    @IBOutlet weak var previewImg: UIImageView!
    
    @IBOutlet weak var namaTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    
    @IBOutlet weak var finishBtn: UIBarButtonItem!
    
    var phoneNumber = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openCamera()
    {
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker = UIImagePickerController()
            picker!.delegate = self;
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            picker!.allowsEditing = true
            picker!.videoMaximumDuration = 15
            self.present(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    
    func openGallary()
    {
        
        picker = UIImagePickerController()
        picker!.delegate = self;
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker!.allowsEditing = true
        picker!.videoMaximumDuration = 15
        
        self.present(picker!, animated: true, completion: nil)
    }
    
    @IBAction func ubahGambar(_ sender: UIButton) {
        
        let alert:UIAlertController=UIAlertController(title: "Upload Gambar", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.modalPresentationStyle = .popover
        
        let screenSize = self.view.frame.height
        if screenSize <= 740.0 {
            // iPhones //
        } else  {
            // iPads //
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect.init(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        }
        
        let cameraAction = UIAlertAction(title: "Kamera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Galeri", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let DeleteAction = UIAlertAction(title: "Hapus", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            
            self.previewImg.image = UIImage.init(named: "Avatar")
            
            self.imgName = ""
            
            if self.fileURL != nil {
                
                try! FileManager.default.removeItem(at: self.fileURL)
                
            }
            
        }
        let cancelAction = UIAlertAction(title: "Batal", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(DeleteAction)
        alert.addAction(cancelAction)
        // Present the actionsheet
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let myPicture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.previewImg.image = myPicture
            
            let imageName = NSUUID().uuidString.replacingOccurrences(of: "-", with: "")
            
            let imagePath = getDocumentsDirectory().appendingPathComponent("\(imageName).jpg")
            
            print(imagePath)
            
            let jpegData = UIImageJPEGRepresentation(myPicture, 0.5)
            
            let imageURL = URL.init(fileURLWithPath: imagePath)
            
            try? jpegData!.write(to: imageURL, options: .atomic)
            
            imgName = imageURL.lastPathComponent
            
            fileURL = imageURL
            
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
    
    @IBAction func checkValue(_ sender: UITextField) {
        
        if namaTF.text! == "" || passTF.text! == "" || confirmPassTF.text! == "" || passTF.text! != confirmPassTF.text! {
        
            finishBtn.isEnabled = false
        
        }else{
        
            finishBtn.isEnabled = true
            
        }
        
    }
    
    @IBAction func selesai(_ sender: UIBarButtonItem) {
        
        let params = [
            "phoneNumber"   : phoneNumber,
            "firstName"     : namaTF.text!,
            "lastName"      : "",
            "sex"           : "",
            "password"      : passTF.text!
        ]
        
        Alamofire.request("\(link().domain)registrasi", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON{response in
        
                if let jason = response.result.value {
                
                    print(JSON(jason).description)
                    
                    let model = user()
                    
                    model.user_id       = JSON(jason)["message"].stringValue
                    model.first_name    = self.namaTF.text!
                    model.last_name     = ""
                    model.sex           = self.namaTF.text!
                    model.no_hp         = self.phoneNumber
                    model.email         = ""
                    model.avatar        = ""
                    
                    DBHelper.insert(obj: model)
                    
                    self.updateToken(user_id: JSON(jason)["message"].stringValue)
                
                }
        
        }
        
    }
    
    func updateToken(user_id: String) {
    
        let token = InstanceID.instanceID().token()!
        
        let params = [
            "userId"        : user_id,
            "registrasiId"  : token
        ]
        
        Alamofire.request("\(link().domain)registrasi-refresh", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON{response in
        
                if let jason = response.result.value {
                
                    print(JSON(jason).description)
                    
                    if JSON(jason)["status"].stringValue == "1" {
                    
                        self.performSegue(withIdentifier: "segue_main", sender: self)
                    
                    }
                
                }
        
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
