//
//  PlacesVC.swift
//  fourSquareClone
//
//  Created by Doğukan Ahi on 27.07.2023.
//

import UIKit
import Parse


class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    var placeNameArray = [String]()
    
    var placeNameID = [String]()
    
    var selectedPlaceID = ""

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        tableview.dataSource = self
        tableview.delegate = self
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addbuttonClicked))
        
        
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logOutButtonClicked))
        
        
        getDataFromParse()
    }
    
    
    
    
    @objc func addbuttonClicked(){
        
        performSegue(withIdentifier: "toUploadVC", sender: nil)
        
    }
    @objc func logOutButtonClicked(){
        PFUser.logOutInBackground {(error) in
            
            if error != nil {
               self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                
                
            }else {
                
                self.performSegue(withIdentifier: "toLoginVC", sender: nil)
            }
            
        }
       
        
        
    }
    
    func getDataFromParse(){
        
        
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { (objects, error) in
         
            if error != nil {
                print("Error occured while getting data from parse!")
                
            }else {
 
                if objects != nil {
                   
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.placeNameID.removeAll(keepingCapacity: false)
                    for object in objects!{
                        
                        if let placeName = object.object(forKey: "name") as? String {
                            if let placeID = object.objectId {
                                
                                self.placeNameArray.append(placeName)
                                self.placeNameID.append(placeID)
                            }
                            
                        }
                        
                        
                    }
                    self.tableview.reloadData()
                }
               
                
                
                
            }
            
        }
        
        
        
    }
    
   func makeAlert (titleInput: String, messageInput: String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
        
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return placeNameID.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPlaceID = placeNameID[indexPath.row]
       performSegue(withIdentifier: "toShowVC", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowVC" {
            let destinationVC = segue.destination as! ShowDetails
            destinationVC.chosenID = selectedPlaceID
            
        }
        
        
        
    }
    
    
}
