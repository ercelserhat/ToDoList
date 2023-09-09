//
//  ChangePasswordViewController.swift
//  TodoList
//
//  Created by Serhat on 10.09.2023.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var newPassAgainTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if newPassTextField.text == ""{
            hataMesaji(titleInput: "HATA", messageInput: "Yeni şifre boş olamaz!")
        }else{
            if newPassTextField.text != newPassAgainTextField.text{
                hataMesaji(titleInput: "HATA", messageInput: "Şifreler birbirine uymuyor!")
            }else{
                Auth.auth().currentUser?.updatePassword(to: newPassTextField.text!){error in
                    if error != nil{
                        self.hataMesaji(titleInput: "HATA", messageInput: error?.localizedDescription ?? "Bir hata oluştu. Lütfen tekrar deneyin.")
                    }else{
                        let alert = UIAlertController(title: "BAŞARILI", message: "Şifreniz değiştirildi.", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "TAMAM", style: .default){action in
                            self.dismiss(animated: true)
                        }
                        alert.addAction(okButton)
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    func hataMesaji(titleInput: String, messageInput: String){
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "TAMAM", style: .default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
    }
}
