//
//  ListNewsController.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/18/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class ListNewsController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var segment: UISegmentedControl!

    @IBOutlet weak var timelineTV: UITableView!
    @IBOutlet weak var newsCV: UICollectionView!
    
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var timelineView: UIView!
    
    @IBOutlet weak var leftConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarStyle(.lightContent)
        
        let swipeLeft = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(ListNewsController.handleSwipeLeft(swipeGesture:)))
        swipeLeft.edges = UIRectEdge.right
        
        let panLeft = UIPanGestureRecognizer.init(target: self, action: #selector(ListNewsController.handleLeftPanGesture(panGesture:)))
        
        self.newsView.addGestureRecognizer(panLeft)
        self.newsView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(ListNewsController.handleSwipeRight(swipeGesture:)))
        swipeRight.edges = UIRectEdge.left
        
        
        let panRight = UIPanGestureRecognizer.init(target: self, action: #selector(ListNewsController.handleRightPanGesture(panGesture:)))
        
        self.timelineView.addGestureRecognizer(panRight)
        self.timelineView.addGestureRecognizer(swipeRight)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = timelineTV.dequeueReusableCell(withIdentifier: "timeline", for: indexPath) 
        return cell
        
    }
    
    @IBAction func changed(_ sender: UISegmentedControl) {
        
        if sender == segment {
        
            if sender.selectedSegmentIndex == 0 {
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.leftConst.constant = 0
                    self.view.layoutIfNeeded()
                
                })
            
            }else if sender.selectedSegmentIndex == 1 {
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.leftConst.constant = 0 - self.view.frame.size.width
                    self.view.layoutIfNeeded()
                    
                })
                
            }
        
        }
        
    }
    
    func showNews() {
    
        segment.selectedSegmentIndex = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.leftConst.constant = 0
            self.view.layoutIfNeeded()
            
        })
    
    }
    
    func showTimeline() {
        
        segment.selectedSegmentIndex = 1
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.leftConst.constant = 0 - self.view.frame.size.width
            self.view.layoutIfNeeded()
            
        })
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = newsCV.dequeueReusableCell(withReuseIdentifier: "news", for: indexPath)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = self.view.frame.size.width / 2 - 10
        let height: CGFloat = width / 9 * 8
        
        return CGSize.init(width: width, height: height)
        
        
    }

    @IBAction func commentAct(_ sender: UIButton) {
        
        let Popover = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "comment") as! CommentController
        
        self.addChildViewController(Popover)
        Popover.view.frame = self.view.frame
        self.view.addSubview(Popover.view)
        Popover.didMove(toParentViewController: self)
        
    }
    
    @IBAction func showMore(_ sender: UIButton) {
        
        let alert:UIAlertController=UIAlertController(title: "More", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.modalPresentationStyle = .popover
        
        let BagikanAction = UIAlertAction(title: "Bagikan", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
        }
        let ReportAction = UIAlertAction(title: "Laporkan", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
        }
        let cancelAction = UIAlertAction(title: "Batal", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        alert.addAction(BagikanAction)
        alert.addAction(ReportAction)
        alert.addAction(cancelAction)
        // Present the actionsheet
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func handleLeftPanGesture(panGesture: UIPanGestureRecognizer) {
        
        let velocity = panGesture.velocity(in: view)
        
        let posEnd = (self.view.frame.size.width / 2) - self.newsView.frame.size.width
        
        if velocity.x > 0 || velocity.x < 0 {
            
            // get translation
            let translation = panGesture.translation(in: view)
            panGesture.setTranslation(CGPoint.zero, in: view)
            
            if translation.x < 0 {
                
                self.leftConst.constant = self.leftConst.constant + translation.x
                
                print(posEnd)
                print(self.newsView.frame.origin.x)
            
            }
            
            if panGesture.state == UIGestureRecognizerState.ended {
                
                print("finish")
                
                if self.newsView.frame.origin.x < posEnd {
                    
                    showTimeline()
                    
                }else{
                    
                    showNews()
                
                }
                
            }
        }
        
    }
    
    func handleRightPanGesture(panGesture: UIPanGestureRecognizer) {
        
        let velocity = panGesture.velocity(in: view)
        
        let posEnd = (self.view.frame.size.width / 2) - self.newsView.frame.size.width
        
        if velocity.x > 0 || velocity.x < 0 {
            
            // get translation
            let translation = panGesture.translation(in: view)
            panGesture.setTranslation(CGPoint.zero, in: view)
            
            if translation.x > 0 {
                
                self.leftConst.constant = self.leftConst.constant + translation.x
                
                print(posEnd)
                print(self.newsView.frame.origin.x)
                
            }
            
            if panGesture.state == UIGestureRecognizerState.ended {
                
                print("finish")
                
                if self.newsView.frame.origin.x > posEnd {
                    
                    showNews()
                    
                }else{
                    
                    showTimeline()
                    
                }
                
            }
        }
        
    }
    
    func handleSwipeLeft(swipeGesture: UIScreenEdgePanGestureRecognizer) {
        
        print("left")
        showTimeline()
    
    }
    
    func handleSwipeRight(swipeGesture: UIScreenEdgePanGestureRecognizer) {
        
        print("right")
        showNews()
        
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
