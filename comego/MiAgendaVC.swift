//
//  MiAgendaVC.swift
//  flasog
//
//  Created by Jonathan Horta on 8/13/17.
//  Copyright © 2017 iddeas. All rights reserved.
//

import UIKit
import UserNotifications
import Alamofire
import SwiftyJSON

extension String {
    /**
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     
     - Parameter length: A `String`.
     - Parameter trailing: A `String` that will be appended after the truncation.
     
     - Returns: A `String` object.
     */
    func truncate(length: Int, trailing: String = "…") -> String {
        if self.characters.count > length {
            return String(self.characters.prefix(length)) + trailing
        } else {
            return self
        }
    }
}
class MiAgendaVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var days : [[String:Any]] = []
    var list : [ProgramItem] = []
    var mylist : [[ProgramItem]] = []
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    let userDefaults = UserDefaults.standard
    let url = "\(getApiBaseUrl())actividades_all/"
    let months = ["", "Enero", "Frebrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
    
    let center = UNUserNotificationCenter.current()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("center")
        center.getPendingNotificationRequests(completionHandler: { (request) in
            for r in request{
                print(r.identifier)
                print("\n")
            }
        })
        print("endcenter")
        loadItems()
        loadStoredItems()
        
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return months.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return mylist[section].count
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return months[section]
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        label.text = months[section]
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica-Bold", size: 18)
        label.backgroundColor = UIColor.lightGray
        
        if section == 0{
            return UIView(frame: CGRect.zero)
        }
        return label
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 30
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let title = view as? UITableViewHeaderFooterView{
            title.textLabel?.textColor =  ColorPallete.BlueColor
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row = mylist[indexPath.section][indexPath.row]
        if let titleLabel = cell.viewWithTag(1) as? UILabel{
            titleLabel.text = row.title
        }
        if let cat = cell.viewWithTag(2) as? UILabel{
            cat.text = row.category
        }
        if let fechas = cell.viewWithTag(3) as? UILabel{
            fechas.text = dateFormatCustom(row.dateStart, row.dateEnd)
        }
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        
        if editingStyle == .delete{
            print("delete")
            
            let row = mylist[indexPath.section][indexPath.row]
            if var storedCats = userDefaults.object(forKey: "my_schedule_comego") as? [Int]{
                let notifIdentifier = "\(row.id)\(row.title)"
                print("Delete Notif:"+notifIdentifier)
                center.removePendingNotificationRequests(withIdentifiers: [notifIdentifier])
                var deleteIndex: Int?
                for (idx,item) in storedCats.enumerated(){
                    if item == row.id{
                        deleteIndex = idx
                    }
                }
                if let i = deleteIndex{
                    storedCats.remove(at: i)
                    userDefaults.set(storedCats, forKey: "my_schedule_comego")
                    userDefaults.synchronize()
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    mylist[indexPath.section].remove(at: indexPath.row)
                    tableView.endUpdates()
                }
            }
//            if var rows = days[indexPath.section]["cats"] as? [MyScheduleItem]{
//                let row = rows[indexPath.row]
//                if var storedCats = userDefaults.object(forKey: "my_schedule") as? [[Int]]{
//                    print(storedCats)
//                    print("CatId:\(row.catId), Id:\(row.id)")
//                    let notifIdentifier = "\(row.id)\(row.subtitle)"
//                    print("Delete Notif:"+notifIdentifier)
//                    center.removePendingNotificationRequests(withIdentifiers: [notifIdentifier])
//                    var deleteIndex: Int?
//                    for (idx,item) in storedCats.enumerated(){
//                        if item[0] == row.catId && item[1] == row.id{
//                            deleteIndex = idx
//                        }
//                    }
//                    if let i = deleteIndex{
//                       storedCats.remove(at: i)
//                        userDefaults.set(storedCats, forKey: "my_schedule")
//                        userDefaults.synchronize()
//                        tableView.beginUpdates()
//                        var indexpaths : [IndexPath] = []
//
//                        tableView.deleteRows(at: [indexPath], with: .automatic)
//                        rows.remove(at: indexPath.row)
//                        days[indexPath.section]["cats"] = rows
//
//
//                        tableView.endUpdates()
//
//                    }
//
//
//                }
//            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProgramItemDetailVC{
            
            if let indexPath = self.tableView.indexPathForSelectedRow{
                vc.programItem = mylist[indexPath.section][indexPath.row]
                 vc.hideBtn = true
            }
        }
    }
    
    
    func loadItems(){
        for _ in months{
            mylist.append([ProgramItem]())
        }
        
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result{
            case .success:
                let actJSON = JSON(response.value ?? [])
                for item in actJSON.arrayValue{
                    
                    let actividad = ProgramItem()
                    actividad.id = item["id"].int!
                    actividad.title = item["title"].string!
                    actividad.desc = item["description"].string!
                    actividad.dresscode = item["dress_code"].string ?? ""
                    actividad.room = item["salon"].string ?? ""
                    actividad.dateStart = item["start_date"].string ?? ""
                    actividad.dateEnd = item["end_date"].string ?? ""
                    actividad.academicProgramUrl = item["academic_program_url"].string ?? ""
                    actividad.inscriptionUrl = item["inscription_url"].string ?? ""
                    actividad.category = item["category"].string ?? ""
                    self.list.append(actividad)
                }
                if let schedule_items = self.userDefaults.object(forKey: "my_schedule_comego") as? [Int]{
                    for i in schedule_items{
                        if let index = self.list.index(where: {$0.id == i}){
                            guard let idx = Int(dateFormatCustom2( self.list[index].dateStart)) else{return}
                            self.mylist[idx].append(self.list[index])
                        }
                    }
                    
                }
                self.tableView.reloadData()
                self.loadingIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    func loadStoredItems(){
//        let titles = [
//            "Cursos Precongreso", // 0
//            "Cursos Transcongreso", // 1
//            "Conferencias Magistrales", // 2
//            "Conferencias Especiales", // 3
//            "Encuentro Latinoamericano de residentes G.O.", // 4
//            "Simposios Especiales", // 5
//            "Simposios Simultaneos", // 6
//            "Foros de discusión" // 7
//        ]
        
//        if let schedule_items = userDefaults.object(forKey: "my_schedule") as? [[Int]]{
//            print(schedule_items)
//
//            for itm in schedule_items{
//                    let day = items[itm[0]].items[itm[1]].dayId
//                    let scheduleItem = MyScheduleItem()
//                    scheduleItem.title = items[itm[0]].title
//                    scheduleItem.subtitle = items[itm[0]].items[itm[1]].title
//                    scheduleItem.schedule = items[itm[0]].items[itm[1]].schedule
//                    scheduleItem.catId = itm[0]
//                    scheduleItem.id = itm[1]
//
//
//
//                    //Modificar agenda para agregar 1 elemento en multiples días (transcongreso)
//                    //Los Transcongreso son los únicos que se agregan en más de 1 día. (6-9 nov)
//                    if scheduleItem.catId == 1{
//                        print("iff")
//                        for i in 2...5{
//
//                            var cats = days[i]["cats"] as! [MyScheduleItem]
//                            cats.append(scheduleItem)
//                            days[i]["cats"] = cats
//
//                        }
//
//                    }
//                    else{
//                        var cats = days[day]["cats"] as! [MyScheduleItem]
//                        cats.append(scheduleItem)
//                        days[day]["cats"] = cats
//                    }
//
//            }
//        }
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
