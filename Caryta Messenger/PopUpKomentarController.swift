//
//  PopUpKomentarController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/15/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import ChameleonFramework

class PopUpKomentarController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var commentTV: UITableView!
    @IBOutlet weak var commentTF: UITextField!
    
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
        
        self.commentTF.becomeFirstResponder()
        showAnimate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PopUpKomentarController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PopUpKomentarController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(PopUpKomentarController.closePopup))
        tapBack.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapBack)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closePopup(){
        self.removeAnimate()
    }
    
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.bottom.constant = 0
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.layoutIfNeeded()
        })
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.5, animations: {
            self.bottom.constant = 0 - 246
            self.view.alpha = 0.0
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.layoutIfNeeded()
        }, completion: {(finished: Bool) in
            if(finished){
                self.view.removeFromSuperview()
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = commentTV.dequeueReusableCell(withIdentifier: "komen", for: indexPath) as! CommentCell
        
        cell.initialLbl.layer.cornerRadius = 20
        cell.initialLbl.clipsToBounds = true
        
        return cell
        
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
