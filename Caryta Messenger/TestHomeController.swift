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
import Alamofire
import SwiftyJSON
import MapleBacon

class TestHomeController: UIViewController, XMSegmentedControlDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var segment: XMSegmentedControl!
    @IBOutlet weak var timelineTV: UITableView!
    @IBOutlet weak var topCV: UICollectionView!
    @IBOutlet weak var newsCV: UICollectionView!
    
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var timelineView: UIView!
    
    @IBOutlet weak var leftConst: NSLayoutConstraint!
    @IBOutlet weak var newsHeight: NSLayoutConstraint!
    
    var length: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("\(link().domain)berita")
            .responseJSON{response in
                
                let jason = response.data!
                
                print(JSON.init(data: jason)["articles"].arrayValue)
                
                for data in JSON.init(data: jason)["articles"].arrayValue {
                    
                    self.sumber.append(data["author"].stringValue)
                    self.judul.append(data["title"].stringValue)
                    self.img.append(data["urlToImage"].stringValue)
                    self.url.append(data["url"].stringValue)
                    
                    print(self.sumber)
                    print(self.judul)
                    print(self.img)
                    print(self.url)
                    
                    self.newsCV.reloadData()
                    
                }
                
        }
        
        self.setStatusBarStyle(.lightContent)
        
        segment.delegate = self
        
        segment.segmentTitle = ["Timeline", "Berita"]
        
        segment.backgroundColor = UIColor.white
        
        segment.highlightColor = UIColor.init(hexString: "008FD7")!
        
        segment.selectedItemHighlightStyle = .background
        
        segment.tint = UIColor.lightGray
        
        segment.highlightTint = UIColor.white
        
        segment.layer.cornerRadius = segment.frame.size.height / 4
        
        segment.selectedSegment = 0
        
        let swipeLeft = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(ListNewsController.handleSwipeLeft(swipeGesture:)))
        swipeLeft.edges = UIRectEdge.right
        
        let panLeft = UIPanGestureRecognizer.init(target: self, action: #selector(ListNewsController.handleLeftPanGesture(panGesture:)))
        
        self.timelineView.addGestureRecognizer(panLeft)
        self.timelineView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(ListNewsController.handleSwipeRight(swipeGesture:)))
        swipeRight.edges = UIRectEdge.left
        
        let panRight = UIPanGestureRecognizer.init(target: self, action: #selector(ListNewsController.handleRightPanGesture(panGesture:)))
        
        self.newsView.addGestureRecognizer(panRight)
        self.newsView.addGestureRecognizer(swipeRight)
        
        // Do any additional setup after loading the view.
    }
    
    var sumber = [String]()
    var judul = [String]()
    var img = [String]()
    var url = [String]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func xmSegmentedControl(_ xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        
        if xmSegmentedControl == segment {
            
            if selectedSegment == 0 {
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.leftConst.constant = 0
                    self.view.layoutIfNeeded()
                    
                })
                
            }else if selectedSegment == 1 {
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.leftConst.constant = 0 - self.view.frame.size.width
                    self.view.layoutIfNeeded()
                    
                })
                
            }
            
        }
        
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
    
    func showNews() {
        
        segment.selectedSegment = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.leftConst.constant = 0
            self.view.layoutIfNeeded()
            
        })
        
    }
    
    func showTimeline() {
        
        segment.selectedSegment = 1
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.leftConst.constant = 0 - self.view.frame.size.width
            self.view.layoutIfNeeded()
            
        })
        
    }
    
    func handleLeftPanGesture(panGesture: UIPanGestureRecognizer) {
        
        let velocity = panGesture.velocity(in: view)
        
        let posEnd = (self.view.frame.size.width / 2) - self.timelineView.frame.size.width
        
        if velocity.x > 0 || velocity.x < 0 {
            
            // get translation
            let translation = panGesture.translation(in: view)
            panGesture.setTranslation(CGPoint.zero, in: view)
            
            if translation.x < 0 {
                
                self.leftConst.constant = self.leftConst.constant + translation.x
                
                print(posEnd)
                print(self.timelineView.frame.origin.x)
                
            }
            
            if panGesture.state == UIGestureRecognizerState.ended {
                
                print("finish")
                
                if self.timelineView.frame.origin.x < posEnd {
                    
                    showTimeline()
                    
                }else{
                    
                    showNews()
                    
                }
                
            }
        }
        
    }
    
    func handleRightPanGesture(panGesture: UIPanGestureRecognizer) {
        
        let velocity = panGesture.velocity(in: view)
        
        let posEnd = (self.view.frame.size.width / 2) - self.timelineView.frame.size.width
        
        if velocity.x > 0 || velocity.x < 0 {
            
            // get translation
            let translation = panGesture.translation(in: view)
            panGesture.setTranslation(CGPoint.zero, in: view)
            
            if translation.x > 0 {
                
                self.leftConst.constant = self.leftConst.constant + translation.x
                
                print(posEnd)
                print(self.timelineView.frame.origin.x)
                
            }
            
            if panGesture.state == UIGestureRecognizerState.ended {
                
                print("finish")
                
                if self.timelineView.frame.origin.x > posEnd {
                    
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.sumber.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = newsCV.dequeueReusableCell(withReuseIdentifier: "news", for: indexPath) as! TestNewsCell
        
        cell.img.setImage(withUrl: URL.init(string: self.img[indexPath.item])!, placeholder: nil, crossFadePlaceholder: true, cacheScaled: false, completion: nil)
        cell.title.text = self.judul[indexPath.item]
        cell.author.text = self.sumber[indexPath.item]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = CGSize()
        
        length = (self.view.frame.size.width - 28) / 2
        
        size = CGSize.init(width: length, height: length)
        
        return size
        
    }
    
    var sentLink = String()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        sentLink = self.url[indexPath.item]
        
        self.performSegue(withIdentifier: "segue_detail_berita", sender: self)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue_detail_berita" {
        
            let next = segue.destination as! TestDetailBeritaController
            
            next.link = self.sentLink
        
        }
        
    }

}
