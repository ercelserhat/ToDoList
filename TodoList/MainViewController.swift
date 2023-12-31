//
//  MainViewController.swift
//  TodoList
//
//  Created by Serhat on 30.08.2023.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var taskTableView: UITableView!
    
    var taskList = [Tasks]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        taskTableView.delegate = self
        taskTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        tumVerileriAl()
    }
    
    func tumVerileriAl(){
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Tasks").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).whereField("durum", isEqualTo: 0).order(by: "eklenme_tarihi", descending: false).addSnapshotListener{snapShot, error in
            if error != nil{
                self.hataMesaji(titleInput: "HATA", messageInput: error?.localizedDescription ?? "Bir hata oluştu. Lütfen tekrar deneyin.")
                print(error!)
            }else{
                if snapShot?.isEmpty != true && snapShot != nil{
                    self.taskList.removeAll(keepingCapacity: false)
                    for document in snapShot!.documents{
                        let documentId = document.documentID
                        if let baslik = document.get("baslik") as? String{
                            if let aciklama = document.get("aciklama") as? String{
                                if let tarih = document.get("tarih") as? String{
                                    if let oncelik = document.get("oncelik") as? Int{
                                        if let durum = document.get("durum") as? Int{
                                            let task = Tasks(documentId: documentId, title: baslik, date: tarih, priority: oncelik, description: aciklama, status: durum)
                                            self.taskList.append(task)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }else{
                    self.taskList = [Tasks]()
                }
                DispatchQueue.main.async {
                    self.taskTableView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indeks = sender as? Int
        if segue.identifier == "toUpdate"{
            let gidilecekVC = segue.destination as! UpdateViewController
            gidilecekVC.gelenTask = taskList[indeks!]
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        cell.taskTitleLabel.text = taskList[indexPath.row].title
        cell.dateLabel.text = taskList[indexPath.row].date
        if taskList[indexPath.row].priority == 1{
            cell.priorityLabel.textColor = UIColor.systemYellow
            cell.exclamationImage.tintColor = UIColor.systemYellow
            cell.priorityLabel.text = "Orta"
        }else if taskList[indexPath.row].priority == 2{
            cell.priorityLabel.text = "Yüksek"
            cell.priorityLabel.textColor = UIColor.systemRed
            cell.exclamationImage.tintColor = UIColor.systemRed
        }else{
            cell.priorityLabel.text = "Düşük"
            cell.priorityLabel.textColor = UIColor.systemBlue
            cell.exclamationImage.tintColor = UIColor.systemBlue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "SİL", handler: {contextualaction, view, boolValue in
            let task = self.taskList[indexPath.row]
            let firestoreDatabase = Firestore.firestore()
            firestoreDatabase.collection("Tasks").document(task.documentId).delete()
        })
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: "TAMAM", handler: {contextualaction, view, boolValue in
            let fireStoreDatabase = Firestore.firestore()
            let task = self.taskList[indexPath.row]
            fireStoreDatabase.collection("Tasks").document(task.documentId).updateData(["durum" : 1])
        })
        doneAction.image = UIImage(systemName: "checkmark.diamond")?.withTintColor(UIColor.white, renderingMode: UIImage.RenderingMode.alwaysOriginal)
        doneAction.backgroundColor = UIColor.systemGreen
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toUpdate", sender: indexPath.row)
    }
    
    //Animation cell
    /*func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0{
            UIView.animate(withDuration: 0.3, delay: 0.5 * Double(indexPath.row), options: [.curveEaseInOut], animations: {
                        cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: 0)
                    }, completion: nil)
        }else{
            UIView.animate(withDuration: 0.3, delay: 0.5 * Double(indexPath.row), options: [.curveEaseInOut], animations: {
                        cell.transform = CGAffineTransform(translationX: -cell.contentView.frame.width, y: 0)
                    }, completion: nil)
        }
    }*/
}
