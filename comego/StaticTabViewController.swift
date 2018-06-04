//
//  StaticTabViewController.swift
//  flasog
//
//  Created by Jonathan Horta on 7/16/17.
//  Copyright © 2017 iddeas. All rights reserved.
//

import UIKit
class StaticTabViewController: UIViewController,UIWebViewDelegate{

    
    @IBOutlet var textView1: UITextView!
    @IBOutlet var textView2: UITextView!
    
    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    

    class func create(storyboardId:String) -> StaticTabViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: storyboardId) as! StaticTabViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if textView1 != nil{
            textView1.contentOffset = CGPoint.zero
        }
        if textView2 != nil{
            textView2.contentOffset = CGPoint.zero
        }
        if webView != nil{
                
            self.loadingIndicator.startAnimating()
            self.webView.loadRequest(URLRequest(url: URL(string:"https://online.flippingbook.com/view/287773/")!))
            
        }
        
    
       
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadingIndicator.stopAnimating()
    }
    
    @objc func didTap() {
//        let fullScreenController = slideshow.presentFullScreenController(from: self)
//        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
//        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
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
