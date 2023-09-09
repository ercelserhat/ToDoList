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
    
    @IBAction func deleteMyAccount(_ sender: Any) {
        let alert = UIAlertController(title: "HESABINIZ SİLİNECEK", message: "Onaylıyor musunuz?\nBu işlem geri alınamaz.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel)
        let okAction = UIAlertAction(title: "Tamam", style: .destructive){action in
            let firestoreDatabase = Firestore.firestore()
            if let emailString = Auth.auth().currentUser?.email{
                firestoreDatabase.collection("Tasks").whereField("email", isEqualTo: emailString).getDocuments{snapShot, error in
                    if error != nil{
                        self.hataMesaji(titleInput: "HATA", messageInput: error?.localizedDescription ?? "Bir hata oluştu. Lütfen tekrar deneyin.")
                        print(error!)
                    }else{
                        if snapShot?.isEmpty != true && snapShot != nil{
                            for document in snapShot!.documents{
                                let documentId = document.documentID
                                firestoreDatabase.collection("Tasks").document(documentId).delete()
                            }
                        }
                    }
                }
                firestoreDatabase.collection("User").whereField("email", isEqualTo: emailString).getDocuments{snapShot, error in
                    if error != nil{
                        self.hataMesaji(titleInput: "HATA", messageInput: error?.localizedDescription ?? "Bir hata oluştu. Lütfen tekrar deneyin.")
                        print(error!)
                    }else{
                        if snapShot?.isEmpty != true && snapShot != nil{
                            for document in snapShot!.documents{
                                let documentId = document.documentID
                                firestoreDatabase.collection("User").document(documentId).delete()
                            }
                        }
                    }
                }
            }
            Auth.auth().currentUser?.delete(){error in
                if error != nil{
                    self.hataMesaji(titleInput: "HATA", messageInput: error?.localizedDescription ?? "Bir hata oluştu. Lütfen tekrar deneyin.")
                }
                do{
                    try Auth.auth().signOut()
                    self.performSegue(withIdentifier: "toViewController", sender: nil)
                }catch{
                    self.hataMesaji(titleInput: "HATA", messageInput: "Hata oluştu. Lütfen tekrar deneyin.")
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
