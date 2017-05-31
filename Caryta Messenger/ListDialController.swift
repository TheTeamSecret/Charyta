//
//  ListDialController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 5/24/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class ListDialController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var name = [String]()
    var dial = [String]()
    
    @IBOutlet weak var dialTV: UITableView!
    
    @IBOutlet weak var dialTVWidth: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 0.3, animations: {
        
            self.dialTVWidth.constant = self.view.frame.size.width
            self.view.layoutIfNeeded()
        
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dialTV.dequeueReusableCell(withIdentifier: "dial", for: indexPath) as! DialCodeCell
        
        cell.countryName.text = name[indexPath.row]
        cell.countryDial.text = dial[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let parent = self.parent as! LoginRegisController
        
        parent.nextBtn.title = "Lanjut"
        parent.countryName.text = name[indexPath.row]
        parent.countryDial.text = dial[indexPath.row]
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.dialTVWidth.constant = 0
            self.view.layoutIfNeeded()
            
        }, completion: {(finished: Bool) in
            if(finished){
                self.view.removeFromSuperview()
            }
        })
        
        
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
