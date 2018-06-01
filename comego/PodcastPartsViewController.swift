//
//  PodcastPartsViewController.swift
//  comego
//
//  Created by Jonathan Horta on 5/23/18.
//  Copyright © 2018 iddeas. All rights reserved.
//

import UIKit

class PodcastPartsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var parts = [PodcastPart]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let podcastItem =  parts[indexPath.row]
        if let label = cell.viewWithTag(1) as? UILabel{
                label.text = podcastItem.title
        }
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WebViewController{
            let index = self.tableView.indexPathForSelectedRow
            if let row = index?.row{
                vc.hideLoading = true
                vc.webUrl = parts[row].url
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
