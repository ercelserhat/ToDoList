//
//  TaskTableViewCell.swift
//  TodoList
//
//  Created by Serhat on 7.09.2023.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var calendarImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var exclamationImage: UIImageView!
    @IBOutlet weak var priorityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
