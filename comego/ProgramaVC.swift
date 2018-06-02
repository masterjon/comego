//
//  ProgramaVC.swift
//  flasog
//
//  Created by Jonathan Horta on 8/4/17.
//  Copyright © 2017 iddeas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProgramaVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

//    var items :[ProgramCat] = loadSchedule()
    var items = [ProgramCat]()
    let url = "\(getApiBaseUrl())actividades_simple/"
    var cems = false
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    class func create(storyboardId:String) -> ProgramaVC {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: storyboardId) as! ProgramaVC
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result{
            case .success:
                let actividadesJSON = JSON(response.value ?? [])
                for item in actividadesJSON.arrayValue{
                    let actividad = ProgramCat()
                    actividad.id = item["id"].int!
                    actividad.title = item["title"].string!
                    actividad.image = item["picture"].string ?? ""
                    actividad.link = item["link"].string ?? ""
                    self.items.append(actividad)
                    
                }
//                let progAcademico = ProgramCat()
//                progAcademico.id = 9999
//                progAcademico.title = "Programa Académico"
//                progAcademico.image = "ProgramaAcademico"
//                self.items.append(progAcademico)
                
                self.collectionView.reloadData()
                self.loadingIndicator.stopAnimating()
                if self.cems{
                    self.performSegue(withIdentifier: "programSegue", sender: 2)
                }
            case .failure(let error):
                print(error)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let imgView = cell.viewWithTag(1) as? UIImageView{
            imgView.image = UIImage(named:"circle")
            let img = items[indexPath.row].image
            Alamofire.request(img).response { response in
            imgView.image = UIImage(data: response.data!)
                
            
            }
            
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProgramaCatDetailVC{
            if let s = sender as? UICollectionViewCell{
                if let indexPath = self.collectionView.indexPath(for: s){
                    vc.cat = self.items[indexPath.row]
                }
            }
            else{
                vc.cat = self.items[sender as! Int]
            }
            
            
            
        }
        else if let vc = segue.destination as? WebViewController{
            vc.webUrl = self.items[5].link
        }
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "programSegue"{
            if let indexPath = self.collectionView.indexPath(for: sender as! UICollectionViewCell){
                if self.items[indexPath.row].link.isEmpty{
                    return true
                }
            }
        }
        else if identifier == "menuSegue"{
            return true
        }
        
        
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !self.items[indexPath.row].link.isEmpty{
            
            performSegue(withIdentifier: "progAcadSegue", sender: nil)
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (self.view.frame.size.width - 25 * 2) / 2 //some width
        let height = (self.view.frame.size.width/2) //ratio
        return CGSize(width: width, height: height)
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
