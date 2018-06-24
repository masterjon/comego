//
//  ViewController.swift
//  flasog
//
//  Created by Jonathan Horta on 6/25/17.
//  Copyright © 2017 iddeas. All rights reserved.
//

import UIKit
import UserNotifications
import ImageSlideshow
import Alamofire
import SwiftyJSON
//import SideMenu
class ViewController: UIViewController {

    let center = UNUserNotificationCenter.current()

    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet weak var ubicacionButton: UIButton!
    var days=0,hours=0, minutes=0, seconds=0
    var secondsLeft = 0
    var timer:Timer?
    let anunciosUrl = "\(getApiBaseUrl())anuncios/"
    var remoteSource = [InputSource]()
    var remoteUrls = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                print("Notifications not allowed")
                
            }
            else{
                print("authorized")
            }
        }
//
//        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "SideMenuNav") as! UISideMenuNavigationController
//        menuLeftNavigationController.leftSide = true
//        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController

        
        let dateString = "26-06-2018 00:00:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: dateString)
        if let secondsLeft = date?.timeIntervalSinceNow{
            self.secondsLeft = Int(secondsLeft)
        }
        
        countdownTimer()
        
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.hidden
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        slideshow.activityIndicator = nil
        Alamofire.request(anunciosUrl).validate().responseJSON { (response) in
            switch response.result{
            case .success:
                let myJSON = JSON(response.value ?? [])
                for item in myJSON.arrayValue{
                    if let sourceImg = AlamofireSource(urlString: item["picture"].string ?? ""){
                        self.remoteSource.append(sourceImg)
                        self.remoteUrls.append(item["link"].string ?? "")
                        
                    }
                }
                self.slideshow.setImageInputs(self.remoteSource)
            case .failure(let error):
                print(error)
            }
        }
        
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    @objc func didTap() {
        print(self.remoteUrls)
        print(slideshow.scrollViewPage)
        print(slideshow.currentPage)
        guard let url = URL(string: self.remoteUrls[slideshow.currentPage]) else{return}
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        print(slideshow.scrollViewPage)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func countdownTimer() {
        print("count")
        print(timer)
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateCounter), userInfo: nil, repeats: true)
            print(timer)
        }else { return }
       

    }
    @objc func updateCounter() {
        
        if(secondsLeft > 0 ) {
        secondsLeft = secondsLeft-1
        //        days = secondsLeft /
        days = secondsLeft / 86400;
        hours = (secondsLeft / 3600) % 24;
        minutes = (secondsLeft / 60) % 60;
        seconds = secondsLeft % 60;
            self.counterLabel.text = "\(String(format: "%02d",days)):\(String(format: "%02d",hours)):\(String(format: "%02d",minutes)):\(String(format: "%02d",seconds))"
       
            //[NSString stringWithFormat:@"%02d:%02d:%02d:%02d",days, hours, minutes, seconds];
        // NSLog(@"%@ SECONDS",self.myCounterLabel.text);
        } else {
        secondsLeft = 0;
        }
    }
    @IBAction func ubicacionAction(_ sender: UIButton) {
        let url = URL(string: "https://www.google.com.mx/maps/place/CANCUN+ICC/@21.1385675,-86.7505158,19.2z/data=!4m5!3m4!1s0x8f4c2c09dc820c41:0x2f257685e799c209!8m2!3d21.1386758!4d-86.7503051?hl=es-419")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    @IBAction func ProfesoresButton(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "TTT")
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Síguenos en ", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Facebook", style: .default, handler: { (action) in
            //execute some code when this option is selected
            let url = URL(string: "https://www.facebook.com/FLASOG2017")!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Twitter", style: .default, handler: { (action) in
            //execute some code when this option is selected
            let url = URL(string: "https://twitter.com/FLASOG2017")!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Instagram", style: .default, handler: { (action) in
            //execute some code when this option is selected
            let url = URL(string: "https://www.instagram.com/FLASOG2017")!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: { (action) in
            //execute some code when this option is selected
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupNotification(_ titleId:String,_ title:String, _ body:String,_ dateString:String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: dateString)
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                    repeats: false)
        
        let identifier = titleId
        print("Add Notif:"+identifier)
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("Something went wrong\(error)")
            }
        })
        
    }

    
    @IBAction func comegoTV(_ sender: UIButton) {
        let url = URL(string: "http://tv.comego.org.mx/")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func podcastBtn(_ sender: UIButton) {
        let nvc = self.storyboard!.instantiateViewController(withIdentifier: "PublicacionesNVC")
        print(nvc.childViewControllers.count)
        if let vc = nvc.childViewControllers[0] as? PublicacionesViewController{
            vc.selctedIndex = 2
        }
        self.present(nvc, animated: false, completion: nil)
        
    }
    @IBAction func inscribeteBtn(_ sender: UIButton) {
        let url = URL(string: "http://bit.ly/2mayanj")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cemsSegue", let vc = segue.destination as? ProgramaCatDetailVC{
            let actividad = ProgramCat()
            actividad.id = 3
            actividad.title = "CEMS Ginecología"
            vc.cat = actividad
        }
        if segue.identifier == "intSegue", let vc = segue.destination as? ProgramaCatDetailVC{
            let actividad = ProgramCat()
            actividad.id = 1
            actividad.title = "Cursos Internacionales"
            vc.cat = actividad
        }
        
    }
    
}

