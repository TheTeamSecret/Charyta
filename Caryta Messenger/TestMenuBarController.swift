//
//  TestMenuBarController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/13/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class TestMenuBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarStyle(.lightContent)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showComment() {
        
        let Popover = UIStoryboard(name: "NewMain", bundle: nil).instantiateViewController(withIdentifier: "komen") as! TestPopUpKomentarController
        
        self.addChildViewController(Popover)
        Popover.view.frame = self.view.frame
        self.view.addSubview(Popover.view)
        Popover.didMove(toParentViewController: self)
    
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
