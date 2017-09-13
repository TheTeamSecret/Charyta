//
//  PopUpListDialController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 8/29/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class PopUpListDialController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var name = [String]()
    var dial = [String]()

    @IBOutlet weak var tbListDial: UITableView!
    @IBOutlet var constTbListDialHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tbListDial.layer.cornerRadius = 5.0
        self.tbListDial.clipsToBounds = true
        self.tbListDial.reloadData()
        
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(PopUpListDialController.selfDismiss))
        tapBack.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapBack)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let newHeight: CGFloat = self.view.frame.size.height - 120
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.constTbListDialHeight.constant = newHeight
            self.view.layoutIfNeeded()
            
        })
        
    }
    
    func selfDismiss() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.constTbListDialHeight.constant = 0
            self.view.layoutIfNeeded()
            
        }, completion: {(finished: Bool) in
            if(finished){
                self.view.removeFromSuperview()
            }
        })
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbListDial.dequeueReusableCell(withIdentifier: "listDial", for: indexPath) as! PopUpListDialCell
        
        cell.lblNama.text = self.name[indexPath.row]
        cell.lblDial.text = self.dial[indexPath.row]
        
        cell.btnList.tag = indexPath.row
        
        return cell
    }
    
    @IBAction func itemSelecteed(_ sender: UIButton) {
        
        let parent = self.parent as! FirstController
        
        parent.dialCodeLbl.text = self.dial[sender.tag]
        parent.dialNameLbl.text = self.name[sender.tag]
        
        parent.setWidth()
        
        selfDismiss()
        
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
