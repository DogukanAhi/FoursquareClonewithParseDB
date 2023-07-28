//
//  UploadVC.swift
//  fourSquareClone
//
//  Created by Doğukan Ahi on 27.07.2023.
//

import UIKit

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    @IBOutlet weak var placefield: UITextField!
    
    
    @IBOutlet weak var placetypefield: UITextField!
    
    @IBOutlet weak var placeatmospherefield: UITextField!
    
    @IBOutlet weak var imageview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageview.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
        imageview.addGestureRecognizer(gestureRecognizer)
        
        
    }
    

    @objc func imageClicked(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker,animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageview.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadButtonClicked(_ sender: Any) {
        
        
        if placefield.text != nil && placetypefield.text != nil && placeatmospherefield.text != nil {
            if let chosenImage =  imageview.image{
                PlaceModel.sharedInstance.placeName = placefield.text!
                PlaceModel.sharedInstance.placeType = placetypefield.text!
                PlaceModel.sharedInstance.placeAtmosphere = placeatmospherefield.text!
                
                PlaceModel.sharedInstance.placeImage = chosenImage
               
            }
            
            performSegue(withIdentifier: "toMapVC", sender: nil)
            
            
        }else {
            makeAlert(titleInput: "Error", messageInput: "Check Your Inputs!")
        }
        
        
    }
    func makeAlert (titleInput: String, messageInput: String){
         
         let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
         let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
         alert.addAction(okButton)
         self.present(alert,animated: true,completion: nil)
         
         
     }
    
    
}
