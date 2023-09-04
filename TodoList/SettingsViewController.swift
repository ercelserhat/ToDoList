//
//  SettingsViewController.swift
//  TodoList
//
//  Created by Serhat on 2.09.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logout(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
            hataMesaji(titleInput: "HATA", messageInput: "Hata oluştu. Lütfen tekrar deneyin.")
        }
    }
    
    func hataMesaji(titleInput: String, messageInput: String){
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "TAMAM", style: .default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
    }
}
