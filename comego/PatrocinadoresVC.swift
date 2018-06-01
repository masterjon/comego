//
//  PatrocinadoresVC.swift
//  flasog
//
//  Created by Jonathan Horta on 8/3/17.
//  Copyright © 2017 iddeas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class PatrocinadoresVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let url = "\(getApiBaseUrl())sponsors/"
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    var sponsors = [(title:String,description:String,url:String,img:String)]()
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result{
            case .success:
                let json = JSON(response.value ?? [])
                for item in json.arrayValue{
                    self.sponsors.append((item["title"].string!, item["description"].string!, item["link"].string!, item["picture"].string!))
                }
                self.tableView.reloadData()
                self.loadingIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let image = cell.viewWithTag(4) as? UIImageView{
            Alamofire.request(sponsors[indexPath.row].img).responseData { (response) in
                image.image = UIImage(data: response.data!)
            }
            
        }
        if let titl = cell.viewWithTag(1) as? UILabel{
            titl.text = sponsors[indexPath.row].title
        }
        if let desc = cell.viewWithTag(2) as? UILabel{
            desc.text = sponsors[indexPath.row].description
        }
//        if let link = cell.viewWithTag(3) as? UILabel{
//            link.text = sponsors[indexPath.row].url
//        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sponsors.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PatrocinadoresDetailVC{
            let index = self.tableView.indexPathForSelectedRow
            if let row = index?.row{
                vc.url = sponsors[row].url
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
