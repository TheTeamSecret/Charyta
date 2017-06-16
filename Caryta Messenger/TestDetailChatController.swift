//
//  TestDetailChatController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/14/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class TestDetailChatController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var initialLbl: UILabel!
    
    @IBOutlet weak var detailChatTV: UITableView!
    @IBOutlet weak var detailChatTVHeight: NSLayoutConstraint!
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(TestDetailChatController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TestDetailChatController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        initialLbl.layer.cornerRadius = 20
        
        initialLbl.clipsToBounds = true
        
        self.detailChatTV.estimatedRowHeight = 46
        self.detailChatTV.rowHeight = UITableViewAutomaticDimension
        
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(TestDetailChatController.endEdit))
        tapBack.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapBack)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = detailChatTV.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as! TestDetailChatCell
        
        let row = indexPath.row
        
        if row == 0 {
            
            cell.blueView.removeFromSuperview()
            cell.readReceipt.removeFromSuperview()
            
            let txt = "Lagi dimana bro?"
            
            cell.whiteLbl.text = txt
            
            let newWidth = self.estimatewidthForView(text: txt).width
            let newHeight = self.estimateHeightForView(text: txt).height
            
            cell.whiteWidth.constant = 20 + newWidth
            
            cell.whiteHeight.constant = 20 + newHeight
            
            cell.whiteView.layer.cornerRadius = 0.0
            
            let maskPath = UIBezierPath(roundedRect: CGRect.init(origin: cell.whiteView.bounds.origin, size: CGSize.init(width: 16 + newWidth, height: 16 + newHeight)), byRoundingCorners: [.topLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: 15.0, height: 15.0))
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            cell.whiteView.layer.mask = maskLayer
        
        }else if row == 1 {
            
            cell.whiteView.removeFromSuperview()
            
            let txt = "Di mes bareng ari, al, dimas, silmy lu dimana? ga ke mes"
            
            cell.blueLbl.text = txt
            
            let newWidth = self.estimatewidthForView(text: txt).width
            let newHeight = self.estimateHeightForView(text: txt).height
            
            cell.blueWidth.constant = 20 + newWidth
            
            cell.blueHeight.constant = 20 + newHeight
            
            cell.blueView.layer.cornerRadius = 0.0
            
            let maskPath = UIBezierPath(roundedRect: CGRect.init(origin: cell.blueView.bounds.origin, size: CGSize.init(width: 16 + newWidth, height: 16 + newHeight)), byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize(width: 15.0, height: 15.0))
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            cell.blueView.layer.mask = maskLayer
            
        }else if row == 2 {
            
            cell.whiteView.removeFromSuperview()
            
            let txt = "Oke udah di jalan"
            
            cell.blueLbl.text = txt
            
            let newWidth = self.estimatewidthForView(text: txt).width
            let newHeight = self.estimateHeightForView(text: txt).height
            
            cell.blueWidth.constant = 20 + newWidth
            
            cell.blueHeight.constant = 20 + newHeight
            
            cell.blueView.layer.cornerRadius = 0.0
            
            let maskPath = UIBezierPath(roundedRect: CGRect.init(origin: cell.blueView.bounds.origin, size: CGSize.init(width: 16 + newWidth, height: 16 + newHeight)), byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize(width: 15.0, height: 15.0))
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            cell.blueView.layer.mask = maskLayer
            
        }else if row == 3 {
            
            cell.whiteView.removeFromSuperview()
            
            let txt = "Macet banget laper lagi"
            
            cell.blueLbl.text = txt
            
            let newWidth = self.estimatewidthForView(text: txt).width
            let newHeight = self.estimateHeightForView(text: txt).height
            
            cell.blueWidth.constant = 20 + newWidth
            
            cell.blueHeight.constant = 20 + newHeight
            
            cell.blueView.layer.cornerRadius = 0.0
            
            let maskPath = UIBezierPath(roundedRect: CGRect.init(origin: cell.blueView.bounds.origin, size: CGSize.init(width: 16 + newWidth, height: 16 + newHeight)), byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize(width: 15.0, height: 15.0))
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            cell.blueView.layer.mask = maskLayer
            
        }
        
        detailChatTVHeight.constant = detailChatTV.contentSize.height
        
        return cell
        
    }
    
    private func estimatewidthForView(text: String) -> CGRect {
        let size = CGSize(width: (self.view.frame.size.width - 100), height: 14)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)], context: nil)
    }
    
    private func estimateHeightForView(text: String) -> CGRect {
        let size = CGSize(width: (self.view.frame.size.width - 100), height: 10000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)], context: nil)
    }
    
    func endEdit() {
    
        self.view.endEditing(true)
    
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
