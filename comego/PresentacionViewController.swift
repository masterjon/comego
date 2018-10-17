//
//  PresentacionViewController.swift
//  comego
//
//  Created by Jonathan Horta on 10/16/18.
//  Copyright © 2018 iddeas. All rights reserved.
//

import UIKit

class PresentacionViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var webView: UIWebView!
    @IBOutlet var profesorLabel: UILabel!
    var presentacion:Presentacion!
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(PresentacionViewController.dismissKeyboard))
        self.view.addGestureRecognizer(recognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(PresentacionViewController.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PresentacionViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.titleLabel.text = presentacion.title
        self.profesorLabel.text = presentacion.profesor
        
        if let url = URL(string:presentacion.pdf){
            self.webView.loadRequest(URLRequest(url: url))
        }
        let commentsKey = "comment-\(presentacion.id)"
        print(commentsKey)
        
        self.textView.layer.borderColor = UIColor.gray.cgColor
        self.textView.layer.borderWidth = 2
        if let text = userDefaults.object(forKey: commentsKey) as? String{
            self.textView.text = text
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
    
    func saveComment() {
        let commentsKey = "comment-\(presentacion.id)"
        userDefaults.set(self.textView.text, forKey: commentsKey)
        userDefaults.synchronize()
    }
    @IBAction func deleteComment(_ sender: UIButton) {
        let alert = UIAlertController(title: "¿Seguro que deseas eliminar esta nota?", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: { (alert) in
            let commentsKey = "comment-\(self.presentacion.id)"
            self.userDefaults.set("", forKey: commentsKey)
            self.userDefaults.synchronize()
            self.textView.text = ""
            
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    @IBAction func shareComment(_ sender: UIButton) {
        let shareText = self.textView.text
        
        let items2Sahre = [shareText] as [Any]
        let shareVC = UIActivityViewController(activityItems: items2Sahre, applicationActivities: nil)
        shareVC.excludedActivityTypes = [UIActivityType.postToWeibo,
                                         UIActivityType.print,
                                         UIActivityType.copyToPasteboard,
                                         UIActivityType.assignToContact,
                                         UIActivityType.saveToCameraRoll,
                                         UIActivityType.addToReadingList,
                                         UIActivityType.postToFlickr,
                                         UIActivityType.postToVimeo,
                                         UIActivityType.postToTencentWeibo,
                                         UIActivityType.airDrop]
        self.present(shareVC, animated: true, completion: nil)
    }
    @objc func dismissKeyboard(){
        self.textView.resignFirstResponder()
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        print("keyboardWillShow")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("HELLO")
            print(self.view.frame.origin.y)
            if self.view.frame.origin.y > 0{
                if self.textView.text == "Ingresa texto"{
                    self.textView.text = ""
                }
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        print("keyboardWillHide")
        saveComment()
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y < 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

}
