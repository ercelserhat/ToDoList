//
//  AddTodoViewController.swift
//  TodoList
//
//  Created by Serhat on 6.09.2023.
//

import UIKit
import Firebase

class AddTodoViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeyiKapat))
        view.addGestureRecognizer(gestureRecognizer)
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        dateTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(self.tarihGoster(datepicker:)), for: .allEvents)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        descriptionTextView.layer.cornerRadius = 5.0
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.layer.masksToBounds = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let tarih = Date()
        let bugun = dateFormatter.string(from: tarih)
        dateTextField.text = bugun
    }
    
    @objc func klavyeyiKapat(){
        view.endEditing(true)
    }
    
    @objc func tarihGoster(datepicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let alinanTarih = dateFormatter.string(from: datepicker.date)
        dateTextField.text = alinanTarih
    }
    
    @IBAction func clearButton(_ sender: Any) {
        temizle()
    }
    
    func temizle(){
        titleTextField.text = ""
        dateTextField.text = ""
        descriptionTextView.text = "Görev açıklaması"
        descriptionTextView.textColor = UIColor.lightGray
        prioritySegmentedControl.selectedSegmentIndex = 1
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if titleTextField.text != ""{
            var aciklama = ""
            if descriptionTextView.text != "Görev açıklaması" && descriptionTextView.text != ""{
                aciklama = descriptionTextView.text
            }
            let firestoreDatabase = Firestore.firestore()
            let firestorePost = ["email" : Auth.auth().currentUser!.email!, "baslik" : titleTextField.text!, "tarih" : dateTextField.text!, "aciklama" : aciklama, "oncelik" : prioritySegmentedControl.selectedSegmentIndex, "eklenme_tarihi" : FieldValue.serverTimestamp(), "durum" : 0] as [String : Any]
            firestoreDatabase.collection("Tasks").addDocument(data: firestorePost){error in
                if error != nil{
                    self.hataMesaji(titleInput: "HATA", messageInput: error?.localizedDescription ?? "Bir hata oluştu. Lütfen tekrar deneyin.")
                }else{
                    self.temizle()
                    self.tabBarController?.selectedIndex = 0
                }
            }
        }else{
            hataMesaji(titleInput: "HATA", messageInput: "Görev başlığı boş olmamalıdır.")
        }
    }
    
    func hataMesaji(titleInput: String, messageInput: String){
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "TAMAM", style: .default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
    }
}

extension AddTodoViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor(named: "dark1")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Görev açıklaması"
            textView.textColor = UIColor.lightGray
        }
    }
}
