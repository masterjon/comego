//
//  NormasViewController.swift
//  comego
//
//  Created by Jonathan Horta on 5/23/18.
//  Copyright © 2018 iddeas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NormasViewController: UIViewController, UITableViewDataSource {


    class func create(storyboardId:String) -> NormasViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: storyboardId) as! NormasViewController
    }
    
    
    let url = "\(getApiBaseUrl())normas/"
    var normas = [(title:String,description:String,url:String)]()
    @IBOutlet var tableView: UITableView!
    
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result{
            case .success:
                let normasJSON = JSON(response.value ?? [])
                for item in normasJSON.arrayValue{
                    self.normas.append((item["title"].string!,item["description"].string!,item["url"].string!))
                }
                self.tableView.reloadData()
                self.loadingIndicator.stopAnimating()
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
        return normas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let label = cell.viewWithTag(1) as? UILabel{
            label.text = normas[indexPath.row].title
        }
        if let label = cell.viewWithTag(2) as? UILabel{
            label.text = normas[indexPath.row].description
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WebViewController{
            let index = self.tableView.indexPathForSelectedRow
            if let row = index?.row{
                vc.webUrl = normas[row].url
                
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
