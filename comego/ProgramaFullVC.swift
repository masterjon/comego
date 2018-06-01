//
//  ProgramaFullVC.swift
//  flasog
//
//  Created by Jonathan Horta on 8/5/17.
//  Copyright © 2017 iddeas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProgramaFullVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var days : [[String:Any]] = []
    var list : [[ProgramItem]] = []
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    let url = "\(getApiBaseUrl())actividades_all/"
    let months = ["", "Enero", "Frebrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
    
    class func create(storyboardId:String) -> ProgramaFullVC {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: storyboardId) as! ProgramaFullVC
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return months.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return list[section].count
        
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
        let row = list[indexPath.section][indexPath.row]
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProgramItemDetailVC{
            
            if let indexPath = self.tableView.indexPathForSelectedRow{
                    vc.programItem = list[indexPath.section][indexPath.row]
                
            }
        }
    }
    
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 0{
           // performSegue(withIdentifier: "ShowTestSegue", sender: Any?)
        }
    }

    func loadItems(){
        

        
        for _ in months{
            list.append([ProgramItem]())
        }
        
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result{
            case .success:
                let actJSON = JSON(response.value ?? [])
                for item in actJSON.arrayValue{
                    guard let startDate = item["start_date"].string else{return}
                    guard let index = Int(dateFormatCustom2(startDate)) else{return}
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
                    self.list[index].append(actividad)
                }
                self.tableView.reloadData()
                self.loadingIndicator.stopAnimating()
                print(self.list)
            case .failure(let error):
                print(error)
            }
            
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
 
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
