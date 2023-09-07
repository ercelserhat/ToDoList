//
//  Task.swift
//  TodoList
//
//  Created by Serhat on 7.09.2023.
//

import Foundation

class Tasks{
    var documentId: String
    var title: String
    var date: String
    var priority: Int
    var description: String
    var status: Int
    
    init(documentId: String ,title: String, date: String, priority: Int, description: String, status: Int) {
        self.documentId = documentId
        self.title = title
        self.date = date
        self.priority = priority
        self.description = description
        self.status = status
    }
    
}
