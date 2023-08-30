//
//  ViewController.swift
//  TodoList
//
//  Created by Serhat on 29.08.2023.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != ""{
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){authdataresult, error in
                if error != nil{
                    self.hataMesaji(titleInput: "HATA", messageInput: error?.localizedDescription ?? "Hata oluştu. Lütfen tekrar deneyin.")
                }else{
                    self.performSegue(withIdentifier: "loginToMain", sender: nil)
                }
            }
        }else{
            hataMesaji(titleInput: "HATA", messageInput: "Email veya şifre boş olamaz!")
        }
    }
    
    func hataMesaji(titleInput: String, messageInput: String){
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "TAMAM", style: .default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
    }
}

