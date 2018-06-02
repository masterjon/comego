//
//  ProgramItemDetailVC.swift
//  flasog
//
//  Created by Jonathan Horta on 8/4/17.
//  Copyright © 2017 iddeas. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation


class ProgramItemDetailVC: UIViewController {
    let userDefaults = UserDefaults.standard
    var programItem:ProgramItem!
    var hideBtn:Bool?
    let center = UNUserNotificationCenter.current()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet var dressCodeLabel: UILabel!
    @IBOutlet var addToBtn: UIButton!
    
    @IBOutlet var academicProgramBtn: UIButton!
    
    @IBOutlet var InscribeteBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let isHiden = hideBtn{
                addToBtn.isHidden = isHiden
        }
        self.titleLabel.text = programItem.title
        let htmlDesc = "<style>body{font-family:Helvetica;font-size:18px;}</style>\(programItem.desc)"
        self.descriptionTextView.attributedText = htmlDesc.htmlToAttributedString
        UIView.animate(withDuration: 0.5, animations: {
                self.descriptionTextView.alpha = 1
        })
        self.daysLabel.text = dateFormatCustom(programItem.dateStart, programItem.dateEnd, lineBreak: true)
        self.dressCodeLabel.text = "Código de vestir: \(programItem.dresscode.capitalized)"
        self.roomLabel.text = "Salón: \(programItem.room)"
        //self.durationLabel.text = "Duración: \(programItem.duration) mins."
        //self.scheduleLabel.text = "Horario: \(programItem.schedule)"
        if !programItem.academicProgramUrl.isEmpty{
            self.academicProgramBtn.isHidden = false
        }
        if !programItem.inscriptionUrl.isEmpty{
            self.InscribeteBtn.isHidden = false
        }
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func addToSchedule(_ sender: UIButton) {
        print("Agregado")
        
        
        let content = UNMutableNotificationContent()
        content.title = "Comienza pronto: \(programItem.category)"
        content.body = programItem.title
        content.sound = UNNotificationSound.default()
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
        var date = dateFormatter.date(from: "2018-01-01T19:00:00-05:00")
        if let dd = dateFormatter.date(from: programItem.dateStart){
             date = dd.addingTimeInterval(15.0 * 60.0 * -1)
        }

        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date!)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                    repeats: false)
        let identifier = "\(programItem.id)\(programItem.title)"
        print("Add Notif:"+identifier)
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)

//
        
        print(programItem.catId)
        let alert2 = UIAlertController(title:"Elemento agregado", message: "", preferredStyle: .alert)
        alert2.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        let alert3 = UIAlertController(title:"Este elemento ya esta en tu agenda", message: "", preferredStyle: .alert)
        alert3.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        let alert4 = UIAlertController(title:"Recuerda", message: "Sólo puedes agregar 1 precongreso y 1 transcongreso a tu agenda. Para poder agregar este elemento necesitas primero quitar de tu agenda el precongreso/transcongreso existente", preferredStyle: .alert)
        alert4.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        if var my_schedule_array = userDefaults.object(forKey: "my_schedule_comego") as? [Int]{
            //if !my_schedule_array.contains(programItem.catId){
            var exists = false
           
            
            for item in my_schedule_array{
                if item == programItem.id{
                   exists = true
                }
            }
//            if (programItem.catId == 0 && preCounter > 0) || (programItem.catId == 1 && transCounter > 0){
//                tooManyCourses = true
//            }
            if !exists {
              
                center.add(request, withCompletionHandler: { (error) in
                    if let error = error {
                        print("Something went wrong\(error)")
                    }
                })
              my_schedule_array.append(programItem.id)
                userDefaults.set(my_schedule_array, forKey: "my_schedule_comego")
                
                self.present(alert2, animated: true, completion: nil)
            }
           
            else if exists{
                self.present(alert3, animated: true, completion: nil)
            }
            
            
            
            //}
            
        }
        else{
            userDefaults.set([programItem.id], forKey: "my_schedule_comego")
            self.present(alert2, animated: true, completion: nil)
        }
        userDefaults.synchronize()
        
        
        
        if let t = userDefaults.object(forKey: "my_schedule_comego") as? [Int]{
            print("my_schedule_comego")
            print(t)
        }
        
        
        
    }
    
    @IBAction func academicProgramAction(_ sender: UIButton) {
            if let url = URL(string: programItem.academicProgramUrl){
                print(url)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
    }
    
    @IBAction func inscribiteAction(_ sender: UIButton) {
        if let url = URL(string: programItem.inscriptionUrl){
            print(url)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
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

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
