//
//  MenuTableViewController.swift
//  flasog
//
//  Created by Jonathan Horta on 8/11/17.
//  Copyright © 2017 iddeas. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    let items = [["title":"Inicio", "vc":"InicioNVC"],
                 ["title":"COLEGIO","vc":"OrganizadoresNVC"],
                 ["title":"PROGRAMA","vc":"ProgramaNVC"],
                 ["title":"CALENDARIO", "vc":"CalendarioNVC"],
                 ["title":"Mi Agenda", "vc":"MiAgendaNVC"],
                 ["title":"PUBLICACIONES","vc":"PublicacionesNVC"],
                 ["title":"NORMATIVIDAD","vc":"NormatividadNVC"],
                 ["title":"COMEGO TV","link":"http://tv.comego.org.mx"],
                 ["title":"PODCAST","link":"http://www.comego.org.mx/index.php/publicaciones/podcast/podcast-comego-y-tu-como-lo-haces"],
                 ["title":"HAZTE MIEMBRO","link":"http://www.comego.org.mx/index.php/comegomenu/como-pertenecer-al-comego/beneficios"],
                 ["title":"GRUPO ÉLITE","vc":"PatrocinadoresNVC"],

    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let title = cell.viewWithTag(1) as? UILabel {
            title.text = items[indexPath.row]["title"]
        }
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let vcTitle = items[indexPath.row]["vc"]{
            if vcTitle.characters.count > 0{
                let vc = self.storyboard!.instantiateViewController(withIdentifier: vcTitle)
                self.present(vc, animated: false, completion: nil)
            }
            
        }
        else if let link = items[indexPath.row]["link"] {
            if let url = URL(string: link){
                print(url)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            
        }
    }
    
    @IBAction func dismissMenu(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
