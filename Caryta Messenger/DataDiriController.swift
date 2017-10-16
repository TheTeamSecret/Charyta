//
//  DataDiriController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 8/10/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import RealmSwift
import DropDown

class DataDiriController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imgProfil: UIImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var btnSelesai: UIButton!
    
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    let listGender = DropDown()
    lazy var dropDowns: [DropDown] = { return [ self.listGender ] }()
    
    let imgPicker = UIImagePickerController()
    var noTelpon = ""
    var fotoSelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DataDiriController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DataDiriController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.imgPicker.delegate = self
        self.imgProfil.layer.cornerRadius = self.imgProfil.frame.height / 2
        self.imgProfil.clipsToBounds = true
        self.setupGender()
        self.btnSelesai.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pilihPhotoTapped(_ sender: UIButton) {
        let alert:UIAlertController=UIAlertController(title: "Upload Foto", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.modalPresentationStyle = .popover
        let cameraAction = UIAlertAction(title: "Kamera", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.cameraTapped()
        }
        let gallaryAction = UIAlertAction(title: "Galeri", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.libraryTapped()
        }
        let cancelAction = UIAlertAction(title: "Batal", style: UIAlertActionStyle.cancel)
        { UIAlertAction in }
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = sender
            presenter.sourceRect = sender.bounds;
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func cameraTapped(){
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            self.imgPicker.sourceType = UIImagePickerControllerSourceType.camera
            //self.imgPicker.mediaTypes = [kUTTypeImage as String]
            self.imgPicker.allowsEditing = true
            self.present(self.imgPicker, animated: true, completion: nil)
        } else {
            libraryTapped()
        }
    }
    
    // Library Image
    func libraryTapped(){
        self.imgPicker.allowsEditing = true
        self.imgPicker.sourceType = .photoLibrary
        present(imgPicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var pickedImage: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            pickedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            pickedImage = originalImage
        }
        self.imgProfil.contentMode = .scaleToFill
        self.imgProfil.image = pickedImage
        //Save to local
        let imageData:NSData = UIImageJPEGRepresentation(pickedImage!, 0.5)! as NSData
        let imageExt = imageData.imageFormat
        let imageUrl = Helper.getDocumentsDirectory().appendingPathComponent("profil.\(imageExt)")
        try? imageData.write(to: URL(fileURLWithPath: imageUrl), options: [.atomic])
        //Encode to Base64
        let imageNsData = NSData(contentsOf: URL(fileURLWithPath: imageUrl))
        let imgBase64 = imageNsData!.base64EncodedString(options: .init(rawValue: 0))
        self.fotoSelected = "data:image/\(imageExt);base64,\(imgBase64)"
        
        dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupGender() {
        listGender.anchorView = self.genderTF
        listGender.bottomOffset = CGPoint(x: 0, y: self.genderTF.bounds.height)
        listGender.dataSource = [
            "Laki-laki",
            "Perempuan"
        ]
        listGender.selectionAction = { [unowned self] (index, item) in
            self.genderTF.text = item
        }
    }
    
    @IBAction func btnPilihGenderTapped(_ sender: UIButton) {
        self.listGender.show()
    }
    
    @IBAction func selesai(_ sender: UIButton) {
        self.registrasi()
    }
    
    func registrasi(){
        let url = "\(link().subDomain)auth/register"
        let head = [
            "Content-Type" : "application/json"
        ]        
        let params = [
            "phoneNumber" : self.noTelpon,
            "photo" : self.fotoSelected,
            "firstName" : self.firstNameTF.text!,
            "lastName" : self.lastNameTF.text!,
            "sex" : self.genderTF.text!,
            "password" : self.passwordTF.text!,
            "firebaseToken" : Helper.token,
            "gambar" : self.fotoSelected
        ]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: head)
            .responseJSON{response in
                if let jason = response.result.value {
                    let data = JSON(jason)
                    if data["status"].intValue == 0 {
                        print(data["message"].stringValue)
                    }else{
                        print(data["message"].stringValue)
                        self.login()
                    }
                }
        }
    }
    
    func login(){
        let url = "\(link().subDomain)auth/login"
        let head = [
            "Content-Type" : "application/json"
        ]
        let params = [
            "username" : self.noTelpon,
            "password" : self.passwordTF.text!
        ]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: head)
            .responseJSON {response in
                if let jason = response.result.value {
                    print(jason)
                    let token = InstanceID.instanceID().token()!
                    let data = JSON(jason)["user"]
                    let model = user()
                    model.user_id       = data["kode_user"].stringValue
                    model.first_name    = data["nama_depan"].stringValue
                    model.last_name     = data["nama_belakang"].stringValue
                    model.email         = data["email"].stringValue
                    model.no_hp         = data["telepon"].stringValue
                    model.sex           = data["jk"].stringValue
                    model.avatar        = data["gambar"].stringValue
                    model.registrasi_id = token
                    DBHelper.insert(obj: model)
                    self.updateToken(data["kode_user"].stringValue, token: token)
                }else{
                    print("Request Gagal")
                }
        }
    }
    
    func updateToken(_ user_id: String, token: String) {
        let params = [
            "kodeUser"       : user_id,
            "firebaseToken"  : token
        ]
        let head = [
            "Content-Type" : "application/json"
        ]
        Alamofire.request("\(link().subDomain)auth/register-refresh", method: .post, parameters: params, encoding: JSONEncoding.default, headers: head)
            .responseJSON{response in
                if let jason = response.result.value {
                    print(JSON(jason).description)
                    if JSON(jason)["status"].stringValue == "1" {
                        self.performSegue(withIdentifier: "segue_main", sender: self)
                    }
                }else{
                    print("Request Gagal")
                }
        }
    }

    @IBAction func btnKembaliTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func keyboardWillShow(_ notification : NSNotification) {
        let keyBoardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        self.bottom.constant = keyBoardSize.height + 16
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(_ notification : Notification) {
        self.bottom.constant = 24.0
        self.view.layoutIfNeeded()
    }
}
