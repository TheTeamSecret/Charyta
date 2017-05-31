//
//  GantiNomorController.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/19/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class GantiNomorController: UIViewController {

    @IBOutlet weak var oldView: UIView!
    @IBOutlet weak var newView: UIView!
    
    @IBOutlet weak var oldTF: UITextField!
    @IBOutlet weak var newTF: UITextField!
    
    @IBOutlet var codeLbl: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oldTF.becomeFirstResponder()
        
        oldView.layer.borderWidth = 1.0
        oldView.layer.borderColor = UIColor.init(hexString: "F1F1F1")!.cgColor
        
        newView.layer.borderWidth = 1.0
        newView.layer.borderColor = UIColor.init(hexString: "F1F1F1")!.cgColor

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for codeNegara in codeLbl {
        
            codeNegara.addBorder(side: .right, thickness: 1.0, color: UIColor.init(hexString: "E1E1E1")!)
        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
