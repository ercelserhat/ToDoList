//
//  RegisterViewController.swift
//  TodoList
//
//  Created by Serhat on 30.08.2023.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func register(_ sender: Any) {
        if nameTextField.text != "" {
            if emailTextField.text != "" && passwordTextField.text != ""{
                if passwordTextField.text == passwordAgainTextField.text{
                    Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){authdataresult, error in
                        if error != nil{
                            self.hataMesaji(titleInput: "HATA", messageInput: error?.localizedDescription ?? "Hata oluştu. Lütfen tekrar deneyin.")
                        }else{
                            let firestoreDatabase = Firestore.firestore()
                            let firestoreUser = ["name" : self.nameTextField.text!, "email" : self.emailTextField.text!, "tarih" : FieldValue.serverTimestamp()] as [String : Any]
                            firestoreDatabase.collection("User").addDocument(data: firestoreUser){ error in
                                if error != nil{
                                    self.hataMesaji(titleInput: "HATA", messageInput: error?.localizedDescription ?? "Hata oluştu. Lütfen tekrar deneyin.")
                                }else{
                                    self.performSegue(withIdentifier: "registerToMain", sender: nil)
                                }
                            }
                        }
                    }
                }else{
                    hataMesaji(titleInput: "HATA", messageInput: "Şifreler birbirine uymuyor!")
                }
            }else{
                hataMesaji(titleInput: "HATA", messageInput: "Email veya şifre boş olamaz!")
            }
        }else{
            hataMesaji(titleInput: "HATA", messageInput: "İsim alanı boş olamaz!")
        }
    }
    
    func hataMesaji(titleInput: String, messageInput: String){
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "TAMAM", style: .default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
    }
}
