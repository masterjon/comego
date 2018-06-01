//
//  MenuCollectionViewController.swift
//  comego
//
//  Created by Jonathan Horta on 5/30/18.
//  Copyright © 2018 iddeas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MenuCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    let items = [["title":"03-INICIO", "vc":"InicioNVC"],
                 ["title":"03-COLEGIO","vc":"OrganizadoresNVC"],
                 ["title":"03-ACTIVIDADES","vc":"ProgramaNVC"],
                 ["title":"03-CALENDARIO", "vc":"CalendarioNVC"],
                 ["title":"03-MISCURSOS", "vc":"MiAgendaNVC"],
                 ["title":"03-PUBLICACIONES","vc":"PublicacionesNVC"],
                 ["title":"03-NORMATIVIDAD","vc":"NormatividadNVC"],
                 ["title":"03-CEMS","vc":"ProgramaNVC"],
                 ["title":"03-COMEGOTV","link":"http://tv.comego.org.mx"],
                 ["title":"03-PODCAST","vc":"PublicacionesNVC"],
                 ["title":"03-COLEGIATE","link":"http://www.comego.org.mx/index.php/comegomenu/como-pertenecer-al-comego/beneficios"],
                 ["title":"03-GRUPOELITE","vc":"PatrocinadoresNVC"],
                 
                 ]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

//        if let title = cell.viewWithTag(1) as? UILabel {
//            title.text = items[indexPath.row]["title"]
//        }
        if let img = cell.viewWithTag(2) as? UIImageView {
            img.image = UIImage(named: items[indexPath.row]["title"]!)
        }
        // Configure the cell...
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vcTitle = items[indexPath.row]["vc"]{
            if vcTitle.count > 0{
                
                let nvc = self.storyboard!.instantiateViewController(withIdentifier: vcTitle)
                if items[indexPath.row]["title"] == "03-PODCAST"{
                    if let vc = nvc.childViewControllers[0] as? PublicacionesViewController{
                        vc.selctedIndex = 2
                    }
                }
                if items[indexPath.row]["title"] == "03-CEMS"{
                    if let vc = nvc.childViewControllers[0] as? ProgramaVC{
                        vc.cems = true
                    }
                }
                self.present(nvc, animated: false, completion: nil)
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (self.view.frame.size.width - (25*2) ) / 3 //some width
        let height = (self.view.frame.size.width - (25*2) - 30) / 3 //ratio
        return CGSize(width: width, height: height)
    }

    @IBAction func dismissMenu(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)

    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
     
    */

}
