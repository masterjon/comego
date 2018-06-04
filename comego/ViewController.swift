//
//  ViewController.swift
//  flasog
//
//  Created by Jonathan Horta on 6/25/17.
//  Copyright © 2017 iddeas. All rights reserved.
//

import UIKit
import UserNotifications

//import SideMenu
class ViewController: UIViewController {

    let center = UNUserNotificationCenter.current()

    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var ubicacionButton: UIButton!
    var days=0,hours=0, minutes=0, seconds=0
    var secondsLeft = 0
    var timer:Timer?
    
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
//        setupNotification("dn-bienvenida", "¡Bienvenidos colegas!", "Hoy se realiza el primer Encuentro Latinoamericano de Residentes en Gineco-Obstetricia.", "04-11-2017 13:00:00")
//
//        setupNotification("dn-bienvenida2", "¡Bienvenido a #FLASOG2017!", "El congreso más importante de Gineco-Obstetricia en Latinoamérica", "04-11-2017 17:00:00")
//
//        setupNotification("dn-dia1", "Hoy se realizan nuestros cursos Precongreso", "Consulta el programa", "05-11-2017 07:00:00")
//
//        setupNotification("dn-dia1_2", "¡Acompáñanos en la inauguración de #FLASOG2017!", "Consulta el salón, código de vestir y horario", "05-11-2017 15:00:00")
//
//
//        setupNotification("dn-dia2", "Hoy arrancamos nuestros cursos Transcongreso y actividades", "Programa tus actividades del día", "06-11-2017 06:30:00")
//
//        setupNotification("dn-dia3", "Colega, prepara tus actividades", "Programa tu agenda para hoy desde nuestra App", "07-11-2017 06:30:00")
//
//        setupNotification("dn-dia4", "¡No te pierdas de nada!", "Programa tu agenda para hoy", "08-11-2017 06:30:00")
//
//        setupNotification("dn-dia5", "Programa tus Actividades", "Han sido excelentes días de aprendizaje, no te pierdas de nada.", "09-11-2017 06:30:00")
//
//        setupNotification("dn-dia5_2", "¡Hoy es la clausura de nuestro congreso!", "Consulta el salón, código y horario", "09-11-2017 11:00:00")
//
//        setupNotification("dn-dia5_3", "¡Gracias por ser parte de nuestro congreso!", "Contigo, la Gineco-Obstetricia de Latinoamérica ¡Crece!", "09-11-2017 15:00:00")
//
//
//        setupNotification("dn-dia5_4", "¡Nos vemos en Paraguay 2020 colegas!", "Manténte pendiente de nuestras redes sociales y espera noticias", "09-11-2017 17:00:00")
//
        //secondsLeft = roundf(date?.timeIntervalSinceNow)
        
        //self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo_blanco"))
        
        // Do any additional setup after loading the view, typically from a nib.
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

