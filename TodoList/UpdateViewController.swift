//
//  UpdateViewController.swift
//  TodoList
//
//  Created by Serhat on 8.09.2023.
//

import UIKit
import Firebase

class UpdateViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    var datePicker: UIDatePicker?
    var gelenTask: Tasks?

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeyiKapat))
        view.addGestureRecognizer(gestureRecognizer)
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        dateTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(self.tarihGoster(datepicker:)), for: .allEvents)
        
        titleTextField.text = gelenTask!.title
        dateTextField.text = gelenTask!.date
        descriptionTextView.text = gelenTask!.description
        prioritySegmentedControl.selectedSegmentIndex = gelenTask!.priority
    }
    
    override func viewWillAppear(_ animated: Bool) {
        descriptionTextView.layer.cornerRadius = 5.0
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        //descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.layer.masksToBounds = true
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

    @IBAction func deleteButton(_ sender: Any) {
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Tasks").document(gelenTask!.documentId).delete()
        self.dismiss(animated: true)
    }
    
    @IBAction func updateButton(_ sender: Any) {
        let firestoreDatabase = Firestore.firestore()
        if let title = titleTextField.text{
            let firestoreUpdatedPost = ["baslik" : title, "tarih" : dateTextField.text!, "aciklama" : descriptionTextView.text! , "oncelik" : prioritySegmentedControl.selectedSegmentIndex] as [String : Any]
            firestoreDatabase.collection("Tasks").document(gelenTask!.documentId).updateData(firestoreUpdatedPost)
        }
        self.dismiss(animated: true)
        
    }
}

extension UpdateViewController: UITextViewDelegate{
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
