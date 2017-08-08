//
//  TestDetailBeritaController.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 8/8/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class TestDetailBeritaController: UIViewController, UIWebViewDelegate {
    
    var link = String()
    @IBOutlet weak var wv: UIWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loading.startAnimating()

        let url = URL.init(string: link)!
        
        let urlReq = URLRequest.init(url: url)
        
        wv.loadRequest(urlReq)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.loading.stopAnimating()
        
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
