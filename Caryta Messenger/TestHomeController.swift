//
//  TestHomeController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/15/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit
import XMSegmentedControl
import ChameleonFramework

class TestHomeController: UIViewController, XMSegmentedControlDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var segment: XMSegmentedControl!
    @IBOutlet weak var timelineTV: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        segment.delegate = self
        
        segment.segmentTitle = ["Timeline", "Berita"]
        
        segment.backgroundColor = UIColor.white
        
        segment.highlightColor = UIColor.init(hexString: "008FD7")!
        
        segment.selectedItemHighlightStyle = .background
        
        segment.tint = UIColor.lightGray
        
        segment.highlightTint = UIColor.white
        
        segment.layer.cornerRadius = segment.frame.size.height / 4
        
        segment.selectedSegment = 0 

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func xmSegmentedControl(_ xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = timelineTV.dequeueReusableCell(withIdentifier: "timeline", for: indexPath) as! TestTimelineCell
        
        cell.initialLbl.layer.cornerRadius = 20
        cell.initialLbl.clipsToBounds = true
        
        return cell
        
    }
    
    @IBAction func showComment(_ sender: UIButton) {
        
        let myParent = self.tabBarController as! TestMenuBarController
            
        myParent.showComment()
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
