//
//  ReglamentosViewController.swift
//  comego
//
//  Created by Jonathan Horta on 5/23/18.
//  Copyright © 2018 iddeas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ReglamentosViewController: UIViewController, UITableViewDataSource {

    class func create(storyboardId:String) -> ReglamentosViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: storyboardId) as! ReglamentosViewController
    }
    let url = "\(getApiBaseUrl())reglamentos/"
    var reglamentos = [(title:String, url:String)]()
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result{
            case .success:
                let reglamentosJSON = JSON(response.value ?? [])
                for item in reglamentosJSON.arrayValue{
                    self.reglamentos.append((item["title"].string!, item["url"].string!))
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reglamentos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let label = cell.viewWithTag(1) as? UILabel{
            label.text = reglamentos[indexPath.row].title
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WebViewController{
            let index = self.tableView.indexPathForSelectedRow
            if let row = index?.row{
                vc.webUrl = reglamentos[row].url
                
            }
        }
        
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
