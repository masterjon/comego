//
//  WebViewController.swift
//  comego
//
//  Created by Jonathan Horta on 5/22/18.
//  Copyright © 2018 iddeas. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView: UIWebView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    var webUrl = ""
    var hideLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if hideLoading{
            self.loadingIndicator.stopAnimating()
        }
        if let url = URL(string:self.webUrl){
            self.webView.loadRequest(URLRequest(url: url))
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadingIndicator.stopAnimating()
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
