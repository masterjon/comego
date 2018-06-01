//
//  StaticTabViewController.swift
//  flasog
//
//  Created by Jonathan Horta on 7/16/17.
//  Copyright © 2017 iddeas. All rights reserved.
//

import UIKit
import ImageSlideshow
class StaticTabViewController: UIViewController,UIWebViewDelegate{

    @IBOutlet var slideshow: ImageSlideshow!
    
    @IBOutlet var textView1: UITextView!
    @IBOutlet var textView2: UITextView!
    
    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    let localSource = [ImageSource(imageString: "F1CUNP10")!, ImageSource(imageString: "F2CUNP10")!, ImageSource(imageString: "F3CUNP10")!, ImageSource(imageString: "F4CUNP10")!,ImageSource(imageString: "F5CUNP10")!,ImageSource(imageString: "F6CUNP10")!,ImageSource(imageString: "F7CUNP10")!,ImageSource(imageString: "F8CUNP10")!]
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
        
        if slideshow != nil{
            slideshow.slideshowInterval = 5.0
            slideshow.pageControlPosition = PageControlPosition.underScrollView
            slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
            slideshow.pageControl.pageIndicatorTintColor = UIColor.black
            slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
            
            // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
            slideshow.activityIndicator = DefaultActivityIndicator()
            slideshow.currentPageChanged = { page in
                print("current page:", page)
            }
            
            // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
            slideshow.setImageInputs(localSource)
            
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(StaticTabViewController.didTap))
            slideshow.addGestureRecognizer(recognizer)
        }
       
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadingIndicator.stopAnimating()
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
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
