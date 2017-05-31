//
//  ListTeleponController.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/16/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase

class ListTeleponController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var listTeleponTV: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isAll: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarStyle(.lightContent)
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(panGesture:)))
        self.listTeleponTV.addGestureRecognizer(panGesture)

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
        
        var row = 0
        
        if isAll == true {
        
            row = 4
        
        }else if isAll == false {
        
            row = 2
        
        }
        
        return row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = listTeleponTV.dequeueReusableCell(withIdentifier: "telepon", for: indexPath) as! ListTeleponCell
        
        cell.nameLbl.text = "Abi Tampilang"
        cell.fromLbl.text = "Ponsel"
        
        if isAll == true {
            
            if indexPath.row > 1 {
                
                cell.nameLbl.textColor = UIColor.flatRed
                cell.typeImg.isHidden = true
                
            }else{
                cell.typeImg.isHidden = false
                
                if indexPath.row == 0 {
                
                    cell.typeImg.image = UIImage.init(named: "Telepon Keluar")
                
                }else if indexPath.row == 1 {
                    
                    cell.typeImg.image = UIImage.init(named: "Telepon masuk")
                    
                }
                
                cell.nameLbl.textColor = UIColor.init(hexString: "929292")
            
            }
            
        }else if isAll == false {
            
            cell.nameLbl.textColor = UIColor.flatRed
            cell.typeImg.isHidden = true
            
        }
        
        return cell
        
    }
    
    @IBAction func changeList(_ sender: UISegmentedControl) {
        
        if sender == segment {
        
            if sender.selectedSegmentIndex == 0 {
            
                isAll = true
                listTeleponTV.reloadData()
            
            }else if sender.selectedSegmentIndex == 1 {
            
                isAll = false
                listTeleponTV.reloadData()
            
            }
            
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(false, animated: true)
        self.view.endEditing(true)
        
    }
    
    @IBAction func goToInfoKontak(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "segue_detail_kontak", sender: self)
        
    }
    
    func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        
        let velocity = panGesture.velocity(in: view)
        
        if velocity.x > 0 || velocity.x < 0 {
            
            // get translation
            let translation = panGesture.translation(in: view)
            panGesture.setTranslation(CGPoint.zero, in: view)
            print(translation)
        
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
