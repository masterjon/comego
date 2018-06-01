//
//  PodcastViewController.swift
//  comego
//
//  Created by Jonathan Horta on 5/22/18.
//  Copyright © 2018 iddeas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class PodcastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    class func create(storyboardId:String) -> PodcastViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: storyboardId) as! PodcastViewController
    }

    @IBOutlet var tableView: UITableView!
    let url = "\(getApiBaseUrl())podcast/"
    var podcastList = [Podcast]()
    var sections = [[Podcast]]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sections.append([Podcast]())
        sections.append([Podcast]())
        
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result{
            case .success:
                let podcastJSON = JSON(response.value ?? [])
                for item in podcastJSON.arrayValue{
                    let podcast = Podcast()
                    podcast.title = item["title"].string!
                    podcast.imageUrl = item["picture"].string ?? ""
                    for part in item["parts"].arrayValue{
                        let partItem = PodcastPart()
                        partItem.title = part["title"].string!
                        partItem.url = part["url"].string!
                        podcast.parts.append(partItem)
                    }
                    self.podcastList.append(podcast)
                    switch item["category"].string!{
                    case "informativo":
                        self.sections[0].append(podcast)
                    case "y_tu_como_lo_haces":
                        self.sections[1].append(podcast)
                    default:
                        break
                    }
                }
                print(self.sections)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let x = sections[section] as? [Podcast]{
            return x.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let podcastItem =  sections[indexPath.section][indexPath.row]
        if let label = cell.viewWithTag(1) as? UILabel{
            label.text = podcastItem.title
        }
        if let imageView = cell.viewWithTag(2) as? UIImageView{
            Alamofire.request(podcastItem.imageUrl).response { response in
                imageView.image = UIImage(data: response.data!)
            }
        }
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PodcastPartsViewController{
            let index = self.tableView.indexPathForSelectedRow
            if let row = index?.row, let section = index?.section{
                vc.parts = self.sections[section][row].parts
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let title = view as? UITableViewHeaderFooterView{
            title.textLabel?.textColor =  ColorPallete.RedColor
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Informativo"
        }else if section == 1{
            return "Y tú como lo haces"
        }
        return ""
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
