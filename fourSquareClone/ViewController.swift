//
//  ViewController.swift
//  fourSquareClone
//
//  Created by Doğukan Ahi on 24.07.2023.
//
import Parse
import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var namefield: UITextField!
    
    @IBOutlet weak var passfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   
        
        
        
    }

    
    @IBAction func loginclicked(_ sender: Any) {
      
        if namefield.text != nil &&  passfield.text != nil {
            
            
            PFUser.logInWithUsername(inBackground: namefield.text!, password: passfield.text!) { (user,error) in
                
                if error != nil {
                    self.makeAlert(titleInput: "Erorr!", messageInput: error?.localizedDescription ?? "Error!")
                }
                else {
                    
                    
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
            
            
        }else {
            makeAlert(titleInput: "Erorr", messageInput:  "Error ENTER USERNAME AND PASSWORD!")
        }
        
        
        
        
        
    }
    

    
    
    @IBAction func signupclicked(_ sender: Any) {
        if namefield.text != nil && passfield.text != nil {
            
            let user = PFUser()
            user.username = namefield.text!
            user.password = passfield.text!
            user.signUpInBackground() { (succes,error) in
                
                if error != nil {
                    print(error?.localizedDescription)
                    
                }
                else {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
            
            
            
        } else {
            makeAlert(titleInput: "Error", messageInput: "Enter username and pass!")
        }
        
        
        
    }
    
    func makeAlert (titleInput: String, messageInput: String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
        
        
    }
    
}

